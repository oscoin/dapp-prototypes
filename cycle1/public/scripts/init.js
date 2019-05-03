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
      imageUrl: '',
      name: 'Radicle',
      websiteUrl: 'https://radicle.xyz',
    },
    contributors: [
      {
        name: 'geigerzaehler',
        imageUrl: 'https://avatars2.githubusercontent.com/u/3919579?s=400&v=4',
      },
      {
        name: 'jameshaydon',
        imageUrl: 'https://avatars2.githubusercontent.com/u/692690?s=400&v=4',
      },
      {
        name: 'jkarni',
        imageUrl: 'https://avatars3.githubusercontent.com/u/1657498?s=400&v=4',
      },
      {
        name: 'MeBrei',
        imageUrl: 'https://avatars1.githubusercontent.com/u/16262137?s=400&v=4',
      },
      {
        name: 'luqui',
        imageUrl: 'https://avatars0.githubusercontent.com/u/22957?s=400&v=4',
      },
      {
        name: 'juliendonck',
        imageUrl: 'https://avatars2.githubusercontent.com/u/2326909?s=400&v=4',
      },
    ],
    maintainers: [
      {
        name: 'jkarni',
        imageUrl: 'https://avatars3.githubusercontent.com/u/1657498?s=400&v=4',
      },
      {
        name: 'jameshaydon',
        imageUrl: 'https://avatars2.githubusercontent.com/u/692690?s=400&v=4',
      },
      {
        name: 'MeBrei',
        imageUrl: 'https://avatars1.githubusercontent.com/u/16262137?s=400&v=4',
      },
    ],
    graph: {
      edges: [
        { direction: 'outgoing', name: 'IPFS', osrank: 0.84 },
        { direction: 'incoming', name: 'Julien package', osrank: 0.99 },
      ],
      osrank: 0.86,
      percentile: 85,
    },
  },
]

window.addEventListener('DOMContentLoaded', _ => {
  console.log(document.getElementById('wallet') ? 'webext' : null)

  var app = Elm.Main.init({
    flags: {
      maybeKeyPair: null,
      maybeWallet: document.getElementById('wallet') ? 'webext' : null,
      projects: initialProjects,
    },
    node: document.getElementById('app'),
  })

  // Check if wallet is installed.
  window.postMessage({
    direction: 'page-to-wallet',
    type: 'getKeyPair',
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

  window.addEventListener('message', function(event) {
    console.log('window.message', event)

    let msg = event.data

    console.log('window.message.msg', msg)

    if (msg.direction === 'wallet-to-page') {
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
