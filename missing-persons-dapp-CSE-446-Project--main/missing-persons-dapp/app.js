let contract;
let accounts;

window.addEventListener('load', async () => {
  if (window.ethereum) {
    window.web3 = new Web3(ethereum);
    await ethereum.enable();
    accounts = await web3.eth.getAccounts();
    const networkId = await web3.eth.net.getId();
    const contractData = await fetch('build/contracts/MissingPersons.json').then(res => res.json());
    const deployedNetwork = contractData.networks[networkId];
    contract = new web3.eth.Contract(contractData.abi, deployedNetwork.address);
    console.log("DApp Loaded", accounts[0]);
  } else {
    alert('Please install MetaMask!');
  }

  document.getElementById("registerForm").onsubmit = async (e) => {
    e.preventDefault();
    const role = document.getElementById("userType").value;
    await contract.methods.register(role).send({ from: accounts[0] });
    alert("Registered as " + role);
  };

  document.getElementById("addPersonForm").onsubmit = async (e) => {
    e.preventDefault();
    const name = document.getElementById("name").value;
    const age = document.getElementById("age").value;
    const location = document.getElementById("location").value;
    await contract.methods.addPerson(name, age, location).send({ from: accounts[0] });
    alert("Missing person reported.");
  };
  if (window.ethereum) {
    window.web3 = new Web3(window.ethereum);
    await window.ethereum.enable();
  }
  
  document.getElementById("updateStatusForm").onsubmit = async (e) => {
    e.preventDefault();
    const id = document.getElementById("personId").value;
    const newStatus = document.getElementById("newStatus").value;
    const statusEnum = { "Missing": 0, "Found": 1, "Investigating": 2 };
    if (statusEnum[newStatus] === undefined) return alert("Invalid status");
    await contract.methods.updateStatus(id, statusEnum[newStatus]).send({ from: accounts[0] });
    alert("Status updated.");
  };

  document.getElementById("assignForm").onsubmit = async (e) => {
    e.preventDefault();
    const id = document.getElementById("caseId").value;
    const investigator = document.getElementById("investigatorAddr").value;
    await contract.methods.assignInvestigator(id, investigator).send({ from: accounts[0] });
    alert("Investigator assigned.");
  };

  async function viewPerson() {
    const person = await contract.methods.getPerson(0).call();
    document.getElementById("personData").textContent = JSON.stringify(person, null, 2);
  }
  

  // You can implement more handlers for booking and searching similarly
});
