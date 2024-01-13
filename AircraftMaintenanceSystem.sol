// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AircraftMaintenanceSystem {
    address public owner;

    struct Aircraft {
        uint256 id;
        string brand;
        uint256 installationDate;
        uint256 lastMaintenanceDate;
        uint256 nextMaintenanceDate;
    }

    struct Maintenance {
        uint256 id;
        uint256 aircraftId;
        uint256 maintenanceDate;
        string maintenanceType;
        bool isCompleted;
    }

    uint256 public nextAircraftId;
    uint256 public nextMaintenanceId;

    mapping(uint256 => Aircraft) public aircrafts;
    mapping(uint256 => Maintenance) public maintenances;

    event AircraftCreated(uint256 id, string brand, uint256 installationDate);
    event MaintenanceCreated(
        uint256 id,
        uint256 aircraftId,
        uint256 maintenanceDate,
        string maintenanceType
    );
    event MaintenanceCompleted(uint256 id);

    modifier onlyOwner() {
        require(msg.sender == owner, 'Only the owner can perform this action');
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createAircraft(
        string memory _brand,
        uint256 _installationDate,
        uint256 _nextMaintenanceDate
    ) public onlyOwner {
        aircrafts[nextAircraftId] = Aircraft({
            id: nextAircraftId,
            brand: _brand,
            installationDate: _installationDate,
            lastMaintenanceDate: 0,
            nextMaintenanceDate: _nextMaintenanceDate
        });

        emit AircraftCreated(
            nextAircraftId,
            _brand,
            _installationDate
        );

        nextAircraftId++;
    }

    function createMaintenance(
        uint256 _aircraftId,
        uint256 _maintenanceDate,
        string memory _maintenanceType
    ) public onlyOwner {
        maintenances[nextMaintenanceId] = Maintenance({
            id: nextMaintenanceId,
            aircraftId: _aircraftId,
            maintenanceDate: _maintenanceDate,
            maintenanceType: _maintenanceType,
            isCompleted: false
        });

        emit MaintenanceCreated(
            nextMaintenanceId,
            _aircraftId,
            _maintenanceDate,
            _maintenanceType
        );

        nextMaintenanceId++;
    }

    function completeMaintenance(uint256 _maintenanceId) public onlyOwner {
        Maintenance storage maintenance = maintenances[_maintenanceId];
        require(!maintenance.isCompleted, 'Maintenance already completed');

        Aircraft storage aircraft = aircrafts[maintenance.aircraftId];
        aircraft.lastMaintenanceDate = maintenance.maintenanceDate;
        
        maintenance.isCompleted = true;
        emit MaintenanceCompleted(_maintenanceId);
    }

    function updateNextMaintenanceDate(
        uint256 _aircraftId,
        uint256 _nextMaintenanceDate
    ) public onlyOwner {
        Aircraft storage elevator = aircrafts[_aircraftId];
        elevator.nextMaintenanceDate = _nextMaintenanceDate;
    }
}