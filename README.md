# Projeto de Rifa NFT

## Descrição

Este projeto implementa um contrato inteligente de rifa na blockchain Ethereum, onde os participantes podem comprar entradas para ter a chance de ganhar um NFT (Token Não Fungível). O projeto foi desenvolvido utilizando a linguagem de programação Solidity.

## Autor

[Je4nDev](https://github.com/Je4nDev)

## Funcionalidades

- Iniciar uma nova rifa com um NFT específico como prêmio.
- Comprar entradas para a rifa.
- Selecionar um vencedor de forma aleatória ao final da rifa.
- Retirar o saldo acumulado no contrato.
- Alterar o custo de entrada durante a rifa.
- Visualizar a lista de participantes e o saldo atual do contrato.

## Como Usar

### Pré-requisitos

- [Node.js](https://nodejs.org/)
- [Truffle](https://www.trufflesuite.com/)
- [Ganache](https://www.trufflesuite.com/ganache)

### Configuração

1. Clone o repositório para o seu local de trabalho.
2. Navegue até a pasta do projeto e instale as dependências com o comando `npm install`.
3. Inicie o Ganache e configure uma nova workspace apontando para o seu projeto.
4. Compile os contratos com o comando `truffle compile`.
5. Faça o deploy dos contratos com o comando `truffle migrate`.

### Testes

Execute os testes com o comando `truffle test`.

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## Contato

Para mais informações, sinta-se à vontade para entrar em contato através do [GitHub](https://github.com/Je4nDev).


















## Getting Started

Create a project using this example:

```bash
npx thirdweb create --contract --template forge-starter
```

You can start editing the page by modifying `contracts/Contract.sol`.

To add functionality to your contracts, you can use the `@thirdweb-dev/contracts` package which provides base contracts and extensions to inherit. The package is already installed with this project. Head to our [Contracts Extensions Docs](https://portal.thirdweb.com/thirdweb-deploy/contract-extensions) to learn more.

## Building the project

After any changes to the contract, run:

```bash
npm run build
# or
yarn build
```

to compile your contracts. This will also detect the [Contracts Extensions Docs](https://portal.thirdweb.com/thirdweb-deploy/contract-extensions) detected on your contract.

## Deploying Contracts

When you're ready to deploy your contracts, just run one of the following command to deploy you're contracts:

```bash
npm run deploy
# or
yarn deploy
```

## Releasing Contracts

If you want to release a version of your contracts publicly, you can use one of the followings command:

```bash
npm run release
# or
yarn release
```

## Join our Discord!

For any questions, suggestions, join our discord at [https://discord.gg/thirdweb](https://discord.gg/thirdweb).
