<!-- ═══════════════════════════ HEADER ═══════════════════════════ -->
<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:020617,50:1e3a8a,100:f59e0b&height=230&section=header&text=Missing%20Persons%20DApp&fontSize=52&fontColor=ffffff&fontAlignY=36&desc=Every%20case%20on-chain.%20Every%20change%20accountable.&descAlignY=58&descSize=18&animation=fadeIn" alt="Missing Persons DApp banner" />
</p>

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=600&size=20&duration=2800&pause=700&color=F59E0B&center=true&vCenter=true&width=700&lines=Decentralised+missing-persons+registry+%F0%9F%94%8E;Role-based+access%3A+Admin+%E2%80%A2+Reporter+%E2%80%A2+Investigator;Tamper-evident+case+history+on+Ethereum+%E2%9B%93%EF%B8%8F;Automatic+urgency+triage+in+Solidity" alt="Typing intro" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Solidity_0.8-363636?style=for-the-badge&logo=solidity&logoColor=white" alt="Solidity" />
  <img src="https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=ethereum&logoColor=white" alt="Ethereum" />
  <img src="https://img.shields.io/badge/Truffle-5E464D?style=for-the-badge&logo=truffle&logoColor=white" alt="Truffle" />
  <img src="https://img.shields.io/badge/Web3.js-F16822?style=for-the-badge&logo=web3dotjs&logoColor=white" alt="Web3.js" />
  <img src="https://img.shields.io/badge/MetaMask-E2761B?style=for-the-badge&logo=metamask&logoColor=white" alt="MetaMask" />
  <img src="https://img.shields.io/badge/Tailwind_CSS-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white" alt="Tailwind" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-f59e0b?style=flat-square" alt="MIT" />
  <img src="https://img.shields.io/github/last-commit/anthonio-alex-dcosta/Missing-persons-dapp?style=flat-square&color=1e3a8a" alt="Last commit" />
  <img src="https://img.shields.io/badge/course-CSE446_Blockchain-0f172a?style=flat-square" alt="CSE446" />
</p>

---

## 🔎 Why a blockchain?

Missing-persons records are trusted only as far as the people who keep them. In a central database, a status can be changed quietly, a report can disappear, and an investigator assignment can be rewritten after the fact.

This DApp moves the **case ledger onto Ethereum**:

- 🧾 **Immutable history.** Every report, status change and assignment is a transaction anyone can audit.
- 🛡️ **Enforced roles.** Permissions live in the smart contract's `onlyRole` modifier, not in a server someone could bypass.
- 📡 **Events.** `PersonAdded`, `StatusUpdated`, `InvestigatorAssigned`, `AppointmentBooked` and `PersonMarkedFound` give a live, verifiable timeline of each case.

---

## 👥 Roles & permissions

<table>
  <tr>
    <th>Capability</th>
    <th align="center">🛡️ Admin</th>
    <th align="center">📝 Reporter</th>
    <th align="center">🕵️ Investigator</th>
  </tr>
  <tr><td>Register a role with a wallet</td><td align="center">deployer</td><td align="center">✅</td><td align="center">✅</td></tr>
  <tr><td>File a missing-person report</td><td align="center">—</td><td align="center">✅</td><td align="center">—</td></tr>
  <tr><td>Update case status</td><td align="center">✅</td><td align="center">—</td><td align="center">—</td></tr>
  <tr><td>Assign an investigator</td><td align="center">✅</td><td align="center">—</td><td align="center">—</td></tr>
  <tr><td>Book a paid appointment (ETH)</td><td align="center">receives fee</td><td align="center">✅</td><td align="center">—</td></tr>
  <tr><td>View appointments and mark found</td><td align="center">—</td><td align="center">—</td><td align="center">✅</td></tr>
</table>

---

## ⚙️ Case lifecycle

```mermaid
stateDiagram-v2
    direction LR
    [*] --> Missing: Reporter files case
    Missing --> Missing: Admin assigns investigator
    Missing --> Found: Admin updates status
    Found --> Closed: Admin closes case
    Missing --> Closed: Admin closes case
    note right of Missing
        Urgency is set automatically on-chain
        age under 18 → High
        age over 50 → Medium
        otherwise → Low
    end note
```

## 🔁 Interaction flow

```mermaid
sequenceDiagram
    autonumber
    actor R as 📝 Reporter
    actor A as 🛡️ Admin
    actor I as 🕵️ Investigator
    participant C as ⛓️ MissingPersonsManagement
    R->>C: addMissingPerson(name, age, location, description)
    C-->>R: emit PersonAdded(id, urgency)
    A->>C: assignInvestigator(id, investigator)
    C-->>A: emit InvestigatorAssigned
    R->>C: bookAppointment(id, admin) + ETH
    C->>A: transfer fee
    C-->>I: emit AppointmentBooked
    I->>C: markFound(id)
    A->>C: updateStatus(id, Found / Closed)
```

---

## 🧩 Contract at a glance

```solidity
enum Role   { None, Admin, Reporter, Investigator }
enum Status { Missing, Found, Closed }

struct MissingPerson {
    uint id;  string name;  uint age;  string location;
    string description;  string urgency;      // High · Medium · Low
    Status status;  address reporter;  address investigator;
}

modifier onlyRole(Role _role) {
    require(users[msg.sender].role == _role, "Access denied");
    _;
}
```

<details>
<summary><b>📂 Project structure</b></summary>

```text
missing-persons-dapp/
├── contracts/MissingPersons.sol     the smart contract
├── build/contracts/                 compiled ABI + deployed network addresses
├── migrations/                      Truffle migration scripts
├── truffle-config.js                network configuration
├── index.html                       Tailwind dashboard (register, report, update, list)
├── app.js                           Web3.js wiring between UI, MetaMask and the contract
└── style.css
```

</details>

---

## 🚀 Run it locally

> **Prerequisites:** Node.js, [Truffle](https://archive.trufflesuite.com/), [Ganache](https://archive.trufflesuite.com/ganache/) (or any local EVM chain) and the MetaMask browser extension.

```bash
cd missing-persons-dapp-CSE-446-Project--main/missing-persons-dapp

# 1 · Start Ganache on 127.0.0.1:7545 (network id 5777)

# 2 · Add a deploy script
cat > migrations/1_deploy.js <<'EOF'
const MissingPersons = artifacts.require("MissingPersonsManagement");
module.exports = (deployer) => deployer.deploy(MissingPersons);
EOF

# 3 · Compile (solc 0.8.21) and deploy
truffle compile
truffle migrate --reset

# 4 · Serve the front end
npx serve .
```

Then connect MetaMask to the Ganache network, import a Ganache account and open the page. The account that deployed the contract becomes the **Admin**.

> 💡 `app.js` loads the ABI from `build/contracts/MissingPersons.json`, while Truffle writes `MissingPersonsManagement.json`. Point the `fetch` path at the generated file, or copy the file to the expected name.

---

<p align="center">
  <a href="https://github.com/anthonio-alex-dcosta"><img src="https://img.shields.io/badge/Built_by-Anthonio_Alex_D_Costa-1e3a8a?style=for-the-badge&logo=github&logoColor=white" alt="Author" /></a>
  <a href="https://anthonio-alex-dcosta.github.io/portfolio/"><img src="https://img.shields.io/badge/Portfolio-f59e0b?style=for-the-badge&logo=googlechrome&logoColor=white" alt="Portfolio" /></a>
</p>

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:f59e0b,50:1e3a8a,100:020617&height=120&section=footer" alt="footer" />
</p>
