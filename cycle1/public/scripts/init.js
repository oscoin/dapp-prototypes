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
  adinapolimndc: {
    keyPair: {
      id: 'adinapoli-mndc',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'Alfredo Di Napoli',
    imageUrl: 'https://avatars0.githubusercontent.com/u/45846748?s=400&v=4',
  },
  angedupre: {
    keyPair: {
      id: 'angedupre',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'Ange Dupre',
    imageUrl: 'https://avatars3.githubusercontent.com/u/2607791?s=400&v=4',
  },
  cloudhead: {
    keyPair: {
      id: 'cloudhead',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'Alexis Sellier',
    imageUrl: 'https://avatars1.githubusercontent.com/u/40774?s=400&v=4',
  },
  emmasiemens: {
    keyPair: {
      id: 'emmasiemens',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'Emma Siemens',
    imageUrl: 'https://avatars0.githubusercontent.com/u/45005753?s=400&v=4',
  },
  hxrts: {
    keyPair: {
      id: 'hxrts',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'Sam Hart',
    imageUrl: 'https://avatars3.githubusercontent.com/u/1831962?s=400&v=4',
  },
  kim: {
    keyPair: {
      id: 'kim',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'Kim Altintop',
    imageUrl: 'https://avatars3.githubusercontent.com/u/6163?s=400&v=4',
  },
  lftherios: {
    keyPair: {
      id: 'lftherios',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'Eleftherios Diakomichalis',
    imageUrl: 'https://avatars3.githubusercontent.com/u/853825?s=400&v=4',
  },
  onurakpolat: {
    keyPair: {
      id: 'onurakpolat',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'Onur Akpolat',
    imageUrl: 'https://avatars2.githubusercontent.com/u/1712926?s=400&v=4',
  },
  xla: {
    keyPair: {
      id: 'xla',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'Alexander Simmerl',
    imageUrl: 'https://avatars0.githubusercontent.com/u/1585?s=400&v=4',
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
      codeHostUrl: 'https://github.com/radicle-dev/radicle',
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
        { direction: 'incoming', name: 'react', osrank: 0.69},
        { direction: 'incoming', name: 'react-dom', osrank: 0.63},
        { direction: 'incoming', name: 'react-router-dom', osrank: 0.68},
        { direction: 'incoming', name: 'react-scripts', osrank: 0.74},
        { direction: 'incoming', name: 'react-timestamp', osrank: 0.41},
        { direction: 'incoming', name: 'styled-components', osrank: 0.73},
        { direction: 'incoming', name: 'eslint-plugin-react', osrank: 0.38},
        { direction: 'incoming', name: 'prettier', osrank: 0.26},
        { direction: 'incoming', name: 'prop-types', osrank: 0.56},
        { direction: 'incoming', name: 'apollo-boost', osrank: 0.19},
        { direction: 'incoming', name: 'graphql', osrank: 0.02},
        { direction: 'incoming', name: 'graphql-tag', osrank: 0.39},
        { direction: 'outgoing', name: 'IPFS', osrank: 0.61 },
        { direction: 'outgoing', name: 'Cabal', osrank: 0.6 },
        { direction: 'outgoing', name: 'Other package', osrank: 0.24 },
        { direction: 'outgoing', name: 'Amazing dependency', osrank: 0.46 },
        { direction: 'outgoing', name: 'Project wow', osrank: 0.84 },
        { direction: 'outgoing', name: 'Botcoin', osrank: 0.37 },
        { direction: 'outgoing', name: 'Bosscoin', osrank: 0.84 },
        { direction: 'outgoing', name: 'IPFS-front-end', osrank: 0.78},
        { direction: 'outgoing', name: 'wowza', osrank: 0.84 },
        { direction: 'outgoing', name: 'Julien package', osrank: 0.02 },
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
  let hasWallet = document.getElementById('wallet') ? true : false

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
    let msg = event.data

    if (msg.direction === 'wallet-to-page') {
      console.log('window.message.msg', msg)
      console.log(msg.type, msg.type === 'transactionsFetched')

      // An existing project was fetched.
      if (msg.type === 'projectFetched' && msg.project !== null) {
        app.ports.projectFetched.send(msg.project)
      }

      // A transaction has been authorized.
      if (msg.type === 'transactionAuthorized') {
        app.ports.transactionAuthorized.send({
          hash: msg.hash,
          keyPairId: msg.keyPairId,
        })
      }

      // A transaction has been reject.
      if (msg.type === 'transactionRejected') {
        app.ports.transactionRejected.send(msg.hash)
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

      // A new key pair was created.
      if (msg.type === 'keyPairCreated') {
        app.ports.keyPairCreated.send(msg.id)
      }

      // An existing key pair was fetched.
      if (msg.type === 'keyPairFetched' && msg.id && msg.id !== null) {
        app.ports.keyPairFetched.send(msg.id)
      }

      // Ongoing transactions are send from the wallet.
      if (msg.type === 'transactionsFetched') {
        console.log('ports.transactionsFetched', msg.transactions)
        app.ports.transactionsFetched.send(msg.transactions)
      }
      // Get notice of transaction progress.
      if (msg.type == 'transactionProgress') {
        console.log('ports.transactionProgress', msg.transaction)

        app.ports.transactionProgress.send(msg.transaction)
      }
    }
  })

  // Fetch key pair if already present.
  window.postMessage({
    direction: 'page-to-wallet',
    type: 'getKeyPair',
  })

  // Fetch transactions if already present.
  window.postMessage({
    direction: 'page-to-wallet',
    type: 'fetchTransactions',
  })
})
