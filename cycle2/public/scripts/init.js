import { encode } from './base32.js'

const fakeKeyPair = {
  id: 'fakeid',
  pubKey: encode(nacl.sign.keyPair().publicKey),
}
const people = {
  clevinson: {
    keyPair: {
      id: 'clevinson',
      pubKey: encode(nacl.sign.keyPair().publicKey),
    },
    name: 'Cory',
    imageUrl: 'https://avatars1.githubusercontent.com/u/832188?s=400&v=4',
  },
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
      reward: 'EqualMaintainer',
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
          source: 'Redhat',
        },
        {
          date: 'Apr. 26, 2019',
          destinations: ['JA', 'JH', 'MB'],
          incoming: 124,
          outgoing: 124,
          rule: { type: 'reward', rule: 'EqualMaintainer' },
          source: 'Network Reward',
        },
        {
          date: 'Apr. 15, 2019',
          destinations: ['RF'],
          incoming: 100,
          outgoing: 0,
          rule: { type: 'donation', rule: 'FundSaving' },
          source: 'Soundcloud',
        },
        {
          date: 'Apr. 9, 2019',
          destinations: ['JA', 'JH', 'MB'],
          incoming: 112,
          outgoing: 112,
          rule: { type: 'reward', rule: 'EqualMaintainer' },
          source: 'Network Reward',
        },
        {
          date: 'Mar. 29, 2019',
          destinations: ['JA', 'JH', 'MB'],
          incoming: 100,
          outgoing: 100,
          rule: { type: 'reward', rule: 'EqualMaintainer' },
          source: 'Network Reward',
        },
      ],
    },
    meta: {
      codeHostUrl: 'https://github.com/juliendonck/Monocle',
      description: 'A peer-to-peer stack for code viewing',
      imageUrl: 'https://res.cloudinary.com/juliendonck/image/upload/v1557488019/Frame_2_bhz6eq.svg',
      name: 'Monocle',
      websiteUrl: 'https://monocle.xyz',
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

window.addEventListener('DOMContentLoaded', _ => {
  Elm.Main.init({
    flags: {
      maybeKeyPair: null,
      projects: initialProjects,
    },
    node: document.getElementById('app'),
  })
})
