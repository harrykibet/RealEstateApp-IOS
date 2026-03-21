//
//  ServiceType.swift
//  model
//
//  Created by builder on 5/3/25.
//


import Foundation

enum ServiceType: String, Codable {
    // General Maintenance and Cleaning
    case maid = "MAID"
    case cleaningService = "CLEANING_SERVICE"
    case plumber = "PLUMBER"
    case electrician = "ELECTRICIAN"
    case gardener = "GARDENER"
    case handyman = "HANDYMAN"
    case pestControl = "PEST_CONTROL"

    // Construction and Renovation
    case interiorDesign = "INTERIOR_DESIGN"
    case architect = "ARCHITECT"
    case constructionWorker = "CONSTRUCTION_WORKER"
    case painter = "PAINTER"
    case roofingSpecialist = "ROOFING_SPECIALIST"
    case tiler = "TILER"
    case flooringExpert = "FLOORING_EXPERT"
    case carpenter = "CARPENTER"
    case renovationContractor = "RENOVATION_CONTRACTOR"

    // Security and Safety
    case securityService = "SECURITY_SERVICE"
    case cctvInstaller = "CCTV_INSTALLER"
    case fireSafetySpecialist = "FIRE_SAFETY_SPECIALIST"
    case locksmith = "LOCKSMITH"

    // Moving and Relocation
    case relocationMover = "RELOCATION_MOVER"
    case storageProvider = "STORAGE_PROVIDER"

    // Legal and Financial
    case insurance = "INSURANCE"
    case propertyLawyer = "PROPERTY_LAWYER"
    case realEstateAgent = "REAL_ESTATE_AGENT"
    case mortgageAdvisor = "MORTGAGE_ADVISOR"

    // Utilities
    case waterSupplySpecialist = "WATER_SUPPLY_SPECIALIST"
    case solarInstaller = "SOLAR_INSTALLER"
    case hvacTechnician = "HVAC_TECHNICIAN"

    // Aesthetic and Outdoor Services
    case landscaper = "LANDSCAPER"
    case poolMaintenance = "POOL_MAINTENANCE"
    case fencingContractor = "FENCING_CONTRACTOR"

    // Special Services
    case homeAutomationSpecialist = "HOME_AUTOMATION_SPECIALIST"
    case applianceRepairTechnician = "APPLIANCE_REPAIR_TECHNICIAN"
    case eventPlanner = "EVENT_PLANNER"
    case wasteDisposal = "WASTE_DISPOSAL"

    // Default
    case unknown = "UNKNOWN"
}
