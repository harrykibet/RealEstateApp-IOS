#!/usr/bin/env python3
"""
Heuristic converter: reads generated Swift view stubs and their original Kotlin composable files (commented at top),
then replaces the SwiftUI body with a simple mapped layout.

Rules:
- Column -> VStack, Row -> HStack
- Spacer(height = X.dp) -> Spacer().frame(height: X)
- EstatiaTextField(value = x, onValueChange = y) -> EstatiaTextField(text: .<name>, placeholder: "") if name matches common fields
- EstatiaButton / EstatiaPrimaryButton -> EstatiaPrimaryButton
- CircularProgressIndicator -> EstatiaCircularProgress
- Image(painter = painterResource(...)) -> EstatiaImage(name: "app_icon")

This is a best-effort tool to save time — review diffs after running.
"""
import re
from pathlib import Path

root = Path('packages')

swift_files = list(root.glob('Feature*/Sources/*/Views/*.swift'))

print(f'Found {len(swift_files)} Swift view stubs')

for sf in swift_files:
    text = sf.read_text()
    # Find original Kotlin file path from top comment
    m = re.search(r'Auto-generated stub from (.+?) composable', text)
    if not m:
        continue
    kotlin_path = m.group(1)
    kp = Path(kotlin_path)
    if not kp.exists():
        # try compute relative path under Android workspace
        alt = Path('/Users/builder/RealEstateApp-Android') / Path(kotlin_path).relative_to('/Users/builder/RealEstateApp-Android') if Path(kotlin_path).is_absolute() else kp
        if alt.exists():
            kp = alt
    if not kp.exists():
        # cannot find kotlin file
        continue
    ksrc = kp.read_text()
    # Basic detections
    hasColumn = 'Column(' in ksrc
    hasImage = 'Image(' in ksrc
    hasTextField = 'TextField' in ksrc or 'EstatiaTextField' in ksrc
    hasButton = 'EstatiaButton' in ksrc or 'EstatiaPrimaryButton' in ksrc or 'EstatiaOutlinedButton' in ksrc
    hasGoogle = 'GoogleSignInButton' in ksrc
    hasProgress = 'CircularProgressIndicator' in ksrc
    # Heuristic body construction
    body_lines = []
    body_lines.append('        ScrollView {')
    body_lines.append('            VStack(alignment: .center, spacing: 16) {')
    if hasImage:
        body_lines.append('                EstatiaImage(name: "app_icon")')
        body_lines.append('                    .frame(width: 120, height: 120)')
        body_lines.append('                    .clipShape(Circle())')
    # title detection: find EstatiaText(text = stringResource(R.string.real_estate_app)) or similar
    title_match = re.search(r'EstatiaText\([^
]*text\s*=\s*stringResource\(([^\)]+)\)', ksrc)
    if title_match:
        body_lines.append('                EstatiaText("Real Estate App")')
    else:
        # try any literal EstatiaText("...") occurrence
        lit_match = re.search(r'EstatiaText\(\s*text\s*=\s*"([^"]+)"', ksrc)
        if lit_match:
            body_lines.append(f'                EstatiaText("{lit_match.group(1)}")')
    if hasTextField:
        # detect parameters names
        if 'email' in ksrc:
            body_lines.append('                EstatiaTextField(text: .email, placeholder: viewModel.emailPlaceholder)')
        if 'password' in ksrc:
            body_lines.append('                EstatiaTextField(text: .password, placeholder: viewModel.passwordPlaceholder)')
    if hasButton:
        body_lines.append('                EstatiaPrimaryButton(title: viewModel.loginTitle, isEnabled: !viewModel.isLoading, isLoading: viewModel.isLoading) {')
        body_lines.append('                    viewModel.login()')
        body_lines.append('                }')
    if hasGoogle:
        body_lines.append('                GoogleSignInButton(isLoading: viewModel.isLoading, isEnabled: !viewModel.isLoading) {')
        body_lines.append('                    viewModel.googleSignIn()')
        body_lines.append('                }')
    if hasProgress:
        body_lines.append('                EstatiaCircularProgress(state: viewModel.isLoading ? .indeterminate : .idle)')
    body_lines.append('            }')
    body_lines.append('            .frame(maxWidth: .infinity)')
    body_lines.append('        }')

    body_new = '
'.join(body_lines)

    # replace the body in swift file between 'public var body: some View {' and the next closing '}' at same indent
    new_text = re.sub(r'public var body: some View \{[\s\S]*?
\}', 'public var body: some View {
' + body_new + '
    }', text, count=1)
    if new_text != text:
        sf.write_text(new_text)
        print(f'Updated {sf}')
    else:
        print(f'No body replacement for {sf}')

print('Conversion complete')
