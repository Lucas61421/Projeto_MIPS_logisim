# **Memory Game - Implementação em MIPS Assembly** 

## **Visão Geral:**
Este projeto consiste na implementação de um **jogo da memória** em Assembly **MIPS**, utilizando o simulador **MARS**. O jogo segue as regras tradicionais: o jogador escolhe duas cartas, que são temporariamente reveladas. Se forem iguais, permanecem visíveis; caso contrário, são ocultadas novamente. O objetivo é encontrar todos os pares para impressão da mensagem final do jogo.


## **Estrutura do Código**
O código foi implementado utilizando **segmentação de memória** (.data e .text) e está dividido em múltiplas funções, cada uma responsável por uma parte específica do jogo.

### **1️ Estruturas de Dados**
- O jogo utiliza duas matrizes principais para armazenar informações:  
  - tabuleiro: Armazena os valores das cartas, garantindo que cada par aparece duas vezes.
  - revelado: Indica se uma carta está **visível (1)** ou **escondida (0)**.

**Declaração em MIPS (.data):**

tabuleiro: .word  1, 2, 3, 4,  1, 2, 3, 4,  5, 6, 7, 8,  5, 6, 7, 8

revelado: .word 
0, 0, 0, 0,
0, 0, 0, 0,
0, 0, 0, 0,
0, 0, 0, 0


### **2️ Entrada e Saída de Dados**
- O jogo interage com o jogador utilizando **syscalls**:
  - **Leitura de coordenadas (linha e coluna)** → syscall 5 (entrada de inteiro).<br> 
  - **Exibição de mensagens** → syscall 4 (impressão de string).<br> 
  - **Exibição do tabuleiro**→ Controlado pela matriz revelado, imprimindo valores ou * para cartas ocultas.<br> 


### **3️ Lógica Principal do Jogo**
1. **Exibir o tabuleiro (mostrar_tabuleiro)**.
2. **Receber as coordenadas das cartas escolhidas (ler_numero)**.
3. **Revelar temporariamente as cartas (revelar_cartas)**.
4. **Verificar se formam um par (checar_par)**.
   - Se forem **iguais**, marcam-se como fixas.
   - Se forem **diferentes**, são ocultadas novamente (esconder_cartas).
5. **Repetir o processo até encontrar todos os pares (loop_principal)**.
6. **Exibir a mensagem de vitória (fim)**.


### **Acesso às Matrizes**
Para o acesso a uma **matriz 4x4** em MIPS é preciso calcular corretamente os endereços de memória:

### **Fórmula**: 
endereço_final = endereço_base + (r * 4 + c) x 4

Cada elemento ocupa **4 bytes ou 32 bits** (.word).

**Implementação em MIPS**:
mul $t2, $s0, $t1  # linha * tamanho da matriz
add $t2, $t2, $s1  # soma a coluna
sll $t2, $t2, 2    # multiplica por 4 (cada elemento ocupa 4 bytes)
la $t3, revelado
add $t3, $t3, $t2  # endereço do elemento na matriz revelado

Isso garante que o código acesse corretamente os valores no **tabuleiro** e na matriz **revelado**.


## **Principais Labels no Código**
| **Label**            | **Função** |
|:-----------------:|:----------------------------:|
| `main`          | Inicializa o jogo. |
| `loop_principal`| Controla a execução principal. |
| `jogar`         | Lê entradas e controla a lógica do jogo. |
| `par_errado`    | Esconde as cartas se não forem um par. |
| `mostrar_tabuleiro` | Exibe o estado atual do tabuleiro. |
| `fim`           | Exibe a mensagem final e encerra o jogo. |


## **Conclusão**
A implementação do Memory Game em MIPS Assembly permitiu reforçar conceitos fundamentais da arquitetura MIPS, como:
  - **Manipulação de matrizes e memória**.<br> 
  - **Uso de syscalls para entrada/saída no console**.<br> 
  - **Controle de fluxo e de laços em Assembly**.<br> 
 
O código mantém a lógica original do jogo e funciona no simulador **MARS**. 
