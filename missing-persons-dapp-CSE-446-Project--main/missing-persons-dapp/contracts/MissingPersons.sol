// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MissingPersonsManagement {
    enum Role { None, Admin, Reporter, Investigator }
    enum Status { Missing, Found, Closed }

    struct User {
        address userAddress;
        Role role;
    }

    struct MissingPerson {
        uint id;
        string name;
        uint age;
        string location;
        string description;
        string urgency; // High, Medium, Low
        Status status;
        address reporter;
        address investigator;
    }

    struct Appointment {
        uint personId;
        address reporter;
        address investigator;
        uint timestamp;
        address payable adminReceiver;
    }

    uint public personCount = 0;
    mapping(address => User) public users;
    mapping(uint => MissingPerson) public missingPersons;
    mapping(address => Appointment[]) public investigatorAppointments;

    event PersonAdded(uint id, string urgency);
    event StatusUpdated(uint id, Status newStatus);
    event InvestigatorAssigned(uint id, address investigator);
    event AppointmentBooked(uint id, address reporter, address investigator);
    event PersonMarkedFound(uint id, address investigator);

    modifier onlyRole(Role _role) {
        require(users[msg.sender].role == _role, "Access denied");
        _;
    }

    constructor() {
        users[msg.sender] = User(msg.sender, Role.Admin);
    }

    function register(Role role) external {
        require(users[msg.sender].role == Role.None, "Already registered");
        users[msg.sender] = User(msg.sender, role);
    }

    function addMissingPerson(
        string memory _name,
        uint _age,
        string memory _location,
        string memory _description
    ) external onlyRole(Role.Reporter) {
        personCount++;
        string memory urgency = (_age < 18) ? "High" : (_age > 50) ? "Medium" : "Low";
        missingPersons[personCount] = MissingPerson(
            personCount,
            _name,
            _age,
            _location,
            _description,
            urgency,
            Status.Missing,
            msg.sender,
            address(0)
        );
        emit PersonAdded(personCount, urgency);
    }

    function updateStatus(uint _id, uint _status) external onlyRole(Role.Admin) {
        require(_status <= uint(Status.Closed), "Invalid status");
        missingPersons[_id].status = Status(_status);
        emit StatusUpdated(_id, Status(_status));
    }

    function assignInvestigator(uint _id, address _investigator) external onlyRole(Role.Admin) {
        require(users[_investigator].role == Role.Investigator, "Invalid investigator");
        missingPersons[_id].investigator = _investigator;
        emit InvestigatorAssigned(_id, _investigator);
    }

    function bookAppointment(uint _id, address payable _adminReceiver) external payable onlyRole(Role.Reporter) {
        require(missingPersons[_id].reporter == msg.sender, "Unauthorized");
        require(missingPersons[_id].investigator != address(0), "No investigator assigned");
        require(msg.value > 0, "Payment required");

        _adminReceiver.transfer(msg.value);

        investigatorAppointments[missingPersons[_id].investigator].push(Appointment(
            _id,
            msg.sender,
            missingPersons[_id].investigator,
            block.timestamp,
            _adminReceiver
        ));

        emit AppointmentBooked(_id, msg.sender, missingPersons[_id].investigator);
    }

    function viewAppointments(address _investigator) external view returns (Appointment[] memory) {
        return investigatorAppointments[_investigator];
    }

    function markFound(uint _id) external onlyRole(Role.Investigator) {
        require(missingPersons[_id].investigator == msg.sender, "Unauthorized");
        emit PersonMarkedFound(_id, msg.sender);
    }

    function getAreaWiseMissingCounts() external view returns (string[] memory areas, uint[] memory counts) {
        // Simplified for now - would need additional mappings for real implementation
        revert("Not implemented yet");
    }
}
