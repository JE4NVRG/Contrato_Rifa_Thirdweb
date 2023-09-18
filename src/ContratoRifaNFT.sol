// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import "@thirdweb-dev/contracts/base/ERC721Base.sol";

/**
 * @title Contrato de Rifa NFT
 * @author Je4nDev
 * @notice Este contrato implementa uma rifa onde os participantes podem comprar entradas para ter a chance de ganhar um NFT.
 */
contract ContratoRifaNFT {
    address public dono; // Endereço do dono do contrato
    mapping(address => uint256) public contagemEntradas; // Mapeia endereços para o número de entradas que eles compraram
    address[] public jogadores; // Lista de todos os jogadores únicos
    address[] public seletorJogadores; // Lista usada para selecionar um vencedor
    bool public statusRifa; // Status atual da rifa (true = em andamento, false = não iniciada ou terminada)
    uint256 public custoEntrada; // Custo para comprar uma entrada na rifa
    address public enderecoNFT; // Endereço do contrato NFT que está sendo usado como prêmio
    uint256 public idNFT; // ID do token NFT que está sendo usado como prêmio
    uint256 public totalEntradas; // Número total de entradas compradas

    // Eventos que são emitidos em várias etapas do processo de rifa
    event NovaEntrada(address jogador);
    event RifaIniciada();
    event RifaEncerrada();
    event VencedorSelecionado(address vencedor);
    event CustoEntradaAlterado(uint256 novoCusto);
    event PremioNFTDefinido(address enderecoNFT, uint256 idNFT);
    event SaldoRetirado(uint256 quantidade);

    // Construtor que inicializa o contrato com o custo de entrada e o dono
    constructor(uint256 _custoEntrada) {
        dono = msg.sender;
        custoEntrada = _custoEntrada;
        statusRifa = false;
        totalEntradas = 0;
    }

    // Modificador que permite apenas que o dono chame certas funções
    modifier somenteDono() {
        require(msg.sender == dono, "Somente o dono pode chamar essa funcao");
        _;
    }

    // Função para iniciar a rifa, definindo o prêmio NFT e marcando a rifa como iniciada
    function iniciarRifa(
        address _contratoNFT,
        uint256 _idToken
    ) public somenteDono {
        require(!statusRifa, "Rifa ja foi iniciada");
        require(enderecoNFT == address(0), "Premio NFT ja foi definido");
        require(
            ERC721Base(_contratoNFT).ownerOf(_idToken) == dono,
            "O dono nao possui o NFT"
        );

        enderecoNFT = _contratoNFT;
        idNFT = _idToken;
        statusRifa = true;
        emit RifaIniciada();
        emit PremioNFTDefinido(_contratoNFT, _idToken);
    }

    // Função para comprar entradas na rifa
    function comprarEntrada(uint256 _quantidadeEntradas) public payable {
        require(statusRifa, "Rifa nao foi iniciada");
        require(
            msg.value == custoEntrada * _quantidadeEntradas,
            "Quantidade de Ether enviada incorreta"
        );

        contagemEntradas[msg.sender] += _quantidadeEntradas;
        totalEntradas += _quantidadeEntradas;

        if (!ehJogador(msg.sender)) {
            jogadores.push(msg.sender);
        }

        for (uint256 i = 0; i < _quantidadeEntradas; i++) {
            seletorJogadores.push(msg.sender);
        }
    }

    // Função para verificar se um endereço é um jogador
    function ehJogador(address _jogador) public view returns (bool) {
        for (uint256 i = 0; i < jogadores.length; i++) {
            if (jogadores[i] == _jogador) {
                return true;
            }
        }
        return false;
    }

    // Função para encerrar a rifa
    function encerrarRifa() public somenteDono {
        require(statusRifa, "Rifa nao foi iniciada");

        statusRifa = false;
        emit RifaEncerrada();
    }

    // Função para selecionar um vencedor aleatório e transferir o NFT para ele
    function selecionarVencedor() public somenteDono {
        require(!statusRifa, "Rifa ainda esta em andamento");
        require(seletorJogadores.length > 0, "Nao ha jogadores na rifa");
        require(enderecoNFT != address(0), "Premio NFT nao foi definido");

        uint256 indiceVencedor = aleatorio() % seletorJogadores.length;
        address vencedor = seletorJogadores[indiceVencedor];
        emit VencedorSelecionado(vencedor);

        ERC721Base(enderecoNFT).transferFrom(dono, vencedor, idNFT);

        resetarEstadoContrato();
    }

    // Função para gerar um número aleatório
    function aleatorio() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.prevrandao,
                        block.timestamp,
                        jogadores.length
                    )
                )
            );
    }

    // Função para resetar a contagem de entradas de todos os jogadores
    function resetarContagemEntradas() private {
        for (uint256 i = 0; i < jogadores.length; i++) {
            contagemEntradas[jogadores[i]] = 0;
        }
    }

    // Função para alterar o custo de entrada
    function alterarCustoEntrada(uint256 _novoCusto) public somenteDono {
        require(!statusRifa, "Rifa ainda esta em andamento");

        custoEntrada = _novoCusto;
        emit CustoEntradaAlterado(_novoCusto);
    }

    // Função para retirar o saldo acumulado no contrato
    function retirarSaldo() public somenteDono {
        require(address(this).balance > 0, "Nao ha saldo para retirar");

        uint256 quantidadeSaldo = address(this).balance;
        payable(dono).transfer(quantidadeSaldo);
        emit SaldoRetirado(quantidadeSaldo);
    }

    // Função para obter a lista de jogadores
    function obterJogadores() public view returns (address[] memory) {
        return jogadores;
    }

    // Função para obter o saldo atual do contrato
    function obterSaldo() public view returns (uint256) {
        return address(this).balance;
    }

    // Função para resetar o estado do contrato
    function resetarEstadoContrato() public somenteDono {
        require(!statusRifa, "Rifa ainda esta em andamento");

        delete seletorJogadores;
        delete jogadores;
        statusRifa = false;
        enderecoNFT = address(0);
        idNFT = 0;
        custoEntrada = 0;
        totalEntradas = 0;
        resetarContagemEntradas();
    }
}
