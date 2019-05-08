import { encode } from './base32.js'

const fakeKeyPair = {
  id: 'fakeid',
  pubKey: encode(nacl.sign.keyPair().publicKey),
}
const people = {
  geigerzaehler: {
    keyPair: {
      id: 'geigerzaehler',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'geigerzaehler',
    imageUrl: 'https://avatars2.githubusercontent.com/u/3919579?s=400&v=4',
  },
  jameshaydon: {
    keyPair: {
      id: 'jameshaydon',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'jameshaydon',
    imageUrl: 'https://avatars2.githubusercontent.com/u/692690?s=400&v=4',
  },
  jkarni: {
    keyPair: {
      id: 'jkarni',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'jkarni',
    imageUrl: 'https://avatars3.githubusercontent.com/u/1657498?s=400&v=4',
  },
  mebrei: {
    keyPair: {
      id: 'mebrei',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'MeBrei',
    imageUrl: 'https://avatars1.githubusercontent.com/u/16262137?s=400&v=4',
  },
  luqui: {
    keyPair: {
      id: 'luqui',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'luqui',
    imageUrl: 'https://avatars0.githubusercontent.com/u/22957?s=400&v=4',
  },
  juliendonck: {
    keyPair: {
      id: 'juliendonck',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'juliendonck',
    imageUrl: 'https://avatars2.githubusercontent.com/u/2326909?s=400&v=4',
  },
}
const initialProjects = [
  {
    address: '1b4atzir794d11ckjtk7xawsqjizgwwabx9bun7qmw5ic7uxr1mj',
    contract: {
      reward: 'Burn',
      donation: 'FundSaving',
      role: 'MaintainerSingleSigner',
    },
    funds: {
      oscoin: 824,
      exchanges: [
        {
          date: 'Apr. 29, 2019',
          destinations: ['RF'],
          incoming: 100,
          outgoing: 0,
          rule: { type: 'donation', rule: 'FundSaving' },
          source: 'IPFS',
        },
        {
          date: 'Apr. 26, 2019',
          destinations: ['JA', 'JH', 'MB'],
          incoming: 124,
          outgoing: 112,
          rule: { type: 'reward', rule: 'EqualMaintainer' },
          source: 'Network Reward',
        },
        {
          date: 'Apr. 15, 2019',
          destinations: ['RF'],
          incoming: 100,
          outgoing: 0,
          rule: { type: 'donation', rule: 'FundSaving' },
          source: 'IPFS',
        },
        {
          date: 'Apr. 9, 2019',
          destinations: ['JA', 'JH', 'MB'],
          incoming: 124,
          outgoing: 112,
          rule: { type: 'reward', rule: 'EqualMaintainer' },
          source: 'Network Reward',
        },
      ],
    },
    meta: {
      codeHostUrl: 'github.com/radicle-dev/radicle',
      description: 'A peer-to-peer stack for code collaboration',
      imageUrl: 'https://avatars0.githubusercontent.com/u/48290027?s=144&v=4',
      name: 'Radicle',
      websiteUrl: 'https://radicle.xyz',
    },
    contributors: [
      people.geigerzaehler,
      people.jameshaydon,
      people.jkarni,
      people.mebrei,
      people.luqui,
      people.juliendonck,
    ],
    maintainers: [people.jkarni, people.jameshaydon, people.mebrei],
    checkpoints: ['abcd123'],
    graph: {
      edges: [
        { direction: 'outgoing', name: 'IPFS', osrank: 0.84 },
        { direction: 'incoming', name: 'Julien package', osrank: 0.99 },
      ],
      osrank: 0.86,
      percentile: 85,
    },
  },
  {
    address: '1b4atzir794d11ckjtk7xfsdqjizgwwabx9bun7qmw5ic7uxr1mj',
    contract: {
      reward: 'Burn',
      donation: 'FundSaving',
      role: 'MaintainerSingleSigner',
    },
    funds: {
      oscoin: 0,
      exchanges: [],
    },
    meta: {
      codeHostUrl: 'github.com/juliendonck',
      description: 'Juliens world',
      imageUrl: 'https://avatars0.githubusercontent.com/u/48290027?s=144&v=4',
      name: 'Julien',
      websiteUrl: 'https://juliendonck.com',
    },
    contributors: [],
    maintainers: [people.juliendonck],
    checkpoints: [],
    graph: {
      edges: [],
      osrank: 0,
      percentile: 0,
    },
  },
]

let cabalAddr = 'cabal#3gd815h0c6x84hj03gd815h0f3gd815h0c6x84hj03gd'
let initialTransactions = [
  // {
  //   hash: 'ba929586d0955940962248f24c3f07305d943e4bea54f3b7e3cc2b98f3edefa0',
  //   fee: 1038,
  //   state: { type: 'denied' },
  //   messages: [{ type: 'project-registration', address: cabalAddr }],
  // },
  // {
  //   hash: 'ba929586d0955940962248f24c3f07305d943e4bea54f3b7e3cc2b98f3edefa1',
  //   fee: 1038,
  //   state: { type: 'unauthorized' },
  //   messages: [{ type: 'project-registration', address: cabalAddr }],
  // },
  // {
  //   hash: 'ba929586d0955940962248f24c3f07305d943e4bea54f3b7e3cc2b98f3edefa2',
  //   fee: 1038,
  //   state: { type: 'wait-to-authorize' },
  //   messages: [{ type: 'project-registration', address: cabalAddr }],
  // },
  // {
  //   hash: 'ba929586d0955940962248f24c3f07305d943e4bea54f3b7e3cc2b98f3edefa3',
  //   fee: 1038,
  //   state: { type: 'unconfirmed', blocks: 0 },
  //   messages: [{ type: 'project-registration', address: cabalAddr }],
  // },
  // {
  //   hash: 'ba929586d0955940962248f24c3f07305d943e4bea54f3b7e3cc2b98f3edefa0',
  //   fee: 1038,
  //   state: { type: 'unconfirmed', blocks: 4 },
  //   messages: [{ type: 'project-registration', address: cabalAddr }],
  // },
  // {
  //   hash: 'ba929586d0955940962248f24c3f07305d943e4bea54f3b7e3cc2b98f3edefa4',
  //   fee: 1038,
  //   state: { type: 'confirmed' },
  //   messages: [
  //     { type: 'project-registration', address: cabalAddr },
  //     {
  //       type: 'update-contract-rule',
  //       address: cabalAddr,
  //       ruleChange: { type: 'reward', old: 'EqualDependency', new: 'Burn' },
  //     },
  //     {
  //       type: 'update-contract-rule',
  //       address: cabalAddr,
  //       ruleChange: {
  //         type: 'donation',
  //         old: 'FundSaving',
  //         new: 'EqualMaintainer',
  //       },
  //     },
  //     {
  //       type: 'update-contract-rule',
  //       address: cabalAddr,
  //       ruleChange: {
  //         type: 'role',
  //         old: 'MaintainerSingleSigner',
  //         new: 'MaintainerMultiSig',
  //       },
  //     },
  //   ],
  // },
]

window.addEventListener('DOMContentLoaded', _ => {
  console.log(document.getElementById('wallet') ? 'webext' : null)

  var app = Elm.Main.init({
    flags: {
      address: encode(nacl.sign.keyPair().publicKey),
      maybeKeyPair: null,
      // maybeKeyPair: people.juliendonck.keyPair,
      maybeWallet: document.getElementById('wallet') ? 'webext' : null,
      pendingTransactions: initialTransactions,
      projects: initialProjects,
    },
    node: document.getElementById('app'),
  })

  // Check if wallet is installed.
  window.postMessage({
    direction: 'page-to-wallet',
    type: 'getKeyPair',
  })

  app.ports.requestProject.subscribe(function(address) {
    console.log('ports.requestProject', address)

    window.postMessage({
      direction: 'page-to-wallet',
      type: 'requestProject',
      address: address,
    })
  })

  app.ports.requireKeyPair.subscribe(function() {
    console.log('ports.requireKeyPair')

    window.postMessage({
      direction: 'page-to-wallet',
      type: 'requireKeyPair',
    })
  })

  // Listen for transcation that need to be signed by the wallet.
  app.ports.signTransaction.subscribe(function(transaction) {
    console.log('ports.signTransaction', transaction)

    window.postMessage({
      direction: 'page-to-wallet',
      type: 'signTransaction',
      transaction: transaction,
    })
  })

  // Store project for later retrieval.
  app.ports.storeProject.subscribe(function(project) {
    console.log('ports.storeProject', project)

    window.postMessage({
      direction: 'page-to-wallet',
      type: 'storeProject',
      project: project,
    })
  })

  window.addEventListener('message', function(event) {
    console.log('window.message', event)

    let msg = event.data

    console.log('window.message.msg', msg)

    if (msg.direction === 'wallet-to-page') {
      // A transaction has been reject.
      if (msg.type === 'transactionRejected') {
        console.log('SENDING', msg.hash)
        app.ports.transactionRejected.send(msg.hash)
      }

      // A transaction has been authorized.
      if (msg.type === 'transactionAuthorized') {
        app.ports.transactionAuthorized.send({
          hash: msg.hash,
          keyPairId: msg.keyPairId,
        })
      }

      // Web extension wallet is signaling presence.
      if (msg.type === 'walletPresent') {
        app.ports.walletWebExtPresent.send(null)

        // Fetch key pair on app startup to reflect state of the wallet.
        window.postMessage({
          direction: 'page-to-wallet',
          type: 'getKeyPair',
        })
      }

      // An existing project was fetched.
      if (msg.type === 'projectFetched' && msg.project !== null) {
        app.ports.projectFetched.send(msg.project)
      }

      // A new key pair was created.
      if (msg.type === 'keyPairCreated') {
        app.ports.keyPairCreated.send(msg.id)
      }

      // An existing key pair was fetched.
      if (msg.type === 'keyPairFetched' && msg.id && msg.id !== null) {
        app.ports.keyPairFetched.send(msg.id)
      }
    }
  })
})
