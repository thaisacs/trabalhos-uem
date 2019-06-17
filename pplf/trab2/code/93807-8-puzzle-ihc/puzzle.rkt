#lang web-server/insta
;#####################
;#   bibliotecas     #
;#####################
(require db)
(require web-server/servlet-env)
(require web-server/managers/lru)
(require rackunit)
(require rackunit/text-ui)
(require data/heap)
;#####################
;#    database       #
;#####################
;CREATE DATABASE trab_2_pplf;
(define pgc
  (mysql-connect #:server "localhost"
                 #:database "trab_2_pplf"
                 #:user "root"
                 #:password "123"))

(query-exec pgc "CREATE TABLE IF NOT EXISTS users (id INT(6) PRIMARY KEY AUTO_INCREMENT,
                                            nickname VARCHAR(30),
                                            score INT(11))")
;#####################
;#     TOP10         #
;#####################
(define level-1 (list 6 4 2 1 5 3 7 0 8))
(define level-2 (list 0 2 5 1 8 3 7 4 6))
(define level-3 (list 8 0 7 6 5 4 3 2 1))
(define level-4 (list 8 3 2 5 1 0 7 4 6))
(define level-5 (list 6 4 7 8 5 0 3 2 1))
;#####################
;#     a-star        #
;#####################
(define K 3) ;;matriz K*K fixada em 3
(define SIZE (- (* K K) 1))
(define T (- K 1))

(define RAM 0) ;;memória usada

(define (index-list count)
  (define (loop i)
    (cond
      [(= i count) (list i)]
      [else (append (list i) (loop (add1 i)))]))
  (loop 0))

(define (create-GOAL)
  (define (loop count)
    (cond
      [(= count (+ 1 SIZE))(list 0)]
      [else (append (list count) (loop (add1 count)))]))
  (loop 1))

(define GOAL (create-GOAL))

(define (create-row i j)
  (cond
    [(= j T) (list(list i j))]
    [else (append (list(list i j)) (create-row i (add1 j)))]))

(define (create-COORDINATES)
  (define (loop i)
    (cond
      [(= i T) (create-row i 0)]
      [else (append (create-row i 0) (loop (add1 i)))]))
  (loop 0))

(define COORDINATES (create-COORDINATES))

;;Número -> Lista 
;;coordenada de um index
(define (index->coordinates index)
    (list-ref COORDINATES index))
;;Lista -> Número
;;index de uma coordenada (3*i+j), (i-linha), (j-coluna)
(define (coordinates->index coordinates)
    (+ (* K (first coordinates)) (second coordinates)))
;;Número -> Número
;;peça em um index
(define (index->tile board index)
    (list-ref board index))
;;Lista Lista -> Número
;;peça em uma coordanada
(define (coordinates->tile board coordinates)
    (index->tile board (coordinates->index coordinates)))
;;Lista Número -> Número
;;index de uma peça
(define (tile->index board tile)
    (-  (length board) (length (memv tile board))))
;;Lista Número -> Lista 
;;coordenada de uma peça
(define (tile->coordinates board tile)
    (index->coordinates (tile->index board tile)))
;;Lista -> Boolean
;;valida se uma cordenada é válida(pertence a COORDINATES)
(define (valid-coordinates? coordinates-and-action)
    (list? (member (first coordinates-and-action) COORDINATES)))
;;Lista -> Lista
;;devolve todas as coordenadas possível para a jogada
(define (coordinates-swap coordinates)
  (filter valid-coordinates?
          (list
           (list (list (- (first coordinates) 1) (second coordinates)) 'UP)
           (list (list (+ (first coordinates) 1) (second coordinates)) 'DOWN)
           (list (list (first coordinates) (- (second coordinates) 1)) 'LEFT)
           (list (list (first coordinates) (+ (second coordinates) 1)) 'RIGHT))))
;;estrutura do nó
(struct node (board g father action h) #:transparent)
;;Node Node -> Boolean
(define (node-<= v1 v2)
  (<= (node-f v1) (node-f v2)))
;;Node -> Número
;;define atributo f (g + h)
(define (node-f v)
    (+ (node-g v) (node-h v)))
;;Lista -> Boolean
;;verifica se o board é final
(define (goal? board)
    (equal? GOAL board))
;;List -> Número
;;heurística 1
(define (h1 n0)
  (define (loop n goal)
  (cond
    [(empty? n) 0]
    [(= 0 (first n)) (+ 0 (loop (rest n) (rest goal)))]
    [else (cond
            [(= (first n) (first goal)) (+ 0 (loop (rest n) (rest goal)))]
            [else (+ 1 (loop (rest n) (rest goal)))])]))
  (loop n0 GOAL))
;;Lista Node String -> Node
;;criar um node
(define (make-node board father action)
  (node board     
        (if (eq? empty father) 0 (+ 1 (node-g father)))
        father
        action
        (h2 board)))
;;List -> Número
;;heurística 2
(define (h2 state)
    (apply + (flatten
               (map (lambda (i)
                      (map (lambda (j)
                             (if (eqv? 0 (list-ref state (+ (* K i) j)))
                                 0
                                 (distance (list-ref state (+ (* K i) j)) i j)))
                           (index-list T)))
                    (index-list T)))))
 ;;Number Number Number -> Number
(define (distance key x y)
  (+ (abs (- (first (list-ref COORDINATES (- key 1))) x))
     (abs (- (second (list-ref COORDINATES (- key 1))) y))))
;;Lista Número Número -> Lista
;;troca a peça tile1 com a tile2
(define (swap-tile board source tile)
    (map (lambda (tile-corrent)
           (cond
             [(= tile-corrent source) tile]
             [(= tile-corrent tile) source]
             [else tile-corrent]))
         board))
;;Lista -> Lista
;;devolve board pra cada possível jogada
(define (get-children board)
  (map (lambda (target-and-action)
         (list
          (swap-tile board 0 (coordinates->tile board (first target-and-action)))
          (second target-and-action)))
       (coordinates-swap (tile->coordinates board 0))))
;;Node -> Lista
;;devolve o board do pai do node
(define (node-father-board node)
    (if (node? (node-father node))
        (node-board (node-father node))
        null))
;;Node -> Lista
;;devolve os novos nodes extraidos de n
(define (EXTRACT n)
  (map
     (lambda (next-board-and-action) (make-node (first next-board-and-action) n (second next-board-and-action)))
     (remove
      (node-father-board n)
      (get-children (node-board n))
      (lambda (father-board board-and-action) (equal? father-board (first board-and-action))))))
;;Node -> Lista
;;devolve os passos tomados para a solução mínima
(define (get-solution n)
  (cond
    [(equal? (node-action n) 'FIM)  (list (node-action n))]
    [else (append (list(node-action n)) (get-solution (node-father n)))]))
;;Lista (Estado Inicial) -> Lista (Solução)
;;a*
(define (a-star INIT)
  ;;OPEN e CLOSED
  (define OPEN (make-heap (lambda (v1 v2) (node-<= v1 v2))))
  (define CLOSED (make-hash))
  
  (heap-add! OPEN (make-node INIT empty 'FIM))
  (set! RAM 0)
  (define (loop)
    (cond
      [(empty? OPEN) (error "OPEN empty")]
      [else
       (define x (heap-min OPEN))
       (heap-remove-min! OPEN)
       (cond
         ((goal? (node-board x)) (get-solution x))
         (else
          (hash-set! CLOSED (node-board x) x)
          (for-each
           (lambda (y)
             (hash-ref CLOSED (node-board y) (lambda () (heap-add! OPEN y) (set! RAM (add1 RAM)))))
           (EXTRACT x))(loop)
          ))]))
  (loop))
;;Número Lista -> Número (inversões)
;;validar board gerado
(define (valid elem0 list-board)
  (define (loop elem list inversions)
    (cond
      [(empty? list) inversions]
      [else (if (or (= (first list) 0) (<= elem (first list)))
                (loop elem (rest list) inversions)
                (loop elem (rest list) (add1 inversions)))]))
  (loop elem0 list-board 0))
;;Lista -> Número
;;soma as inversões
(define (valid-loop list-board)
    (cond
      [(empty? list-board) 0]
      [else (if (= 0 (first list-board))
                (valid-loop (rest list-board))
                (+ (valid (first list-board) (rest list-board)) (valid-loop (rest list-board))))]))
;;Lista -> Número (par (0) ou ímpar (1))
;;pega mod da quantidade de inversões por 2
(define (valid-game list-board)
  (remainder (valid-loop list-board) 2))
;;Lista Número -> Lista
;;novo tabuleiro
(define (random-board new-list size)
  (cond
    [(= size (length new-list)) new-list]
    [else (define index (random size))
          (if (equal? (member index new-list) #f)
              (random-board (append new-list (list index)) size)
              (random-board new-list size))]))
;; -> Lista
;;gera um board aleatório e válido
(define (new-board)
  (define lista (random-board (list) (+ 1 SIZE)))
  (cond
    [(= 0 (valid-game lista)) lista]
    [else (new-board)]))
;#####################
;#     web app       #
;#####################
;;estrutura de dados do usuário
(struct user(id nickname score))
;;lista top10
(define lista(list))
;;User -> Lista
;;adiciona usuário ao top10
(define (append-element elem)
  (set! lista (append lista (list elem))))
;;pega top10 do banco de dados
(define (load-users)
  (for ([(i n s) (in-query pgc "SELECT * FROM users ORDER BY score LIMIT 10")])
    (define u(user i n s))
    (append-element u)))
(load-users)
;;atualiza lista top10
(define (load-users-2)
  (define l(list))
  (for ([(i n s) (in-query pgc "SELECT * FROM users ORDER BY score LIMIT 10")])
    (define u(user i n s))
    (set! l (append l (list u))))
  (set! lista l))
;;requisições
;;chama página index
(define (start request)
  (show-index request))
;;chama a página solve
(define (heuristica request)
  (show-h request))
;;chama página treinar
(define (treinar request)
  (show-treinar request))
;;chama página help
(define (help request)
  (show-help request))
;;pega nickname do submit
  (define (parse-nickname bindings)
    (extract-binding/single 'nickname bindings))
;;definição da página index
(define (show-index request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html (head (title "8-PUZZLE"))
            (link ((rel "stylesheet")
                   (href "/vendor/bootstrap/css/bootstrap.min.css")
                   (type "text/css")))
            (link ((rel "stylesheet")
                   (href "/vendor/font-awesome/css/font-awesome.min.css")
                   (type "text/css")))
            (link ((rel "stylesheet")
                   (href "https://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic")
                   (type "text/css")))
            (link ((rel "stylesheet")
                   (href "https://fonts.googleapis.com/css?family=Cabin:700")
                   (type "text/css")))
            (link ((rel "stylesheet")
                   (href "/css/grayscale.min.css")
                   (type "text/css")))
            (link ((rel "stylesheet")
                   (href "/css/tamanho.css")
                   (type "text/css")))
            (body ([id "page-top"])
                  ;nav
                  (nav ([class "navbar navbar-expand-lg navbar-light fixed-top"] [id "mainNav"])
                       (div ((class "container"))
                            (div ([class "collapse navbar-collapse"][id "navbarResponsive"])
                                 (ul ((class "navbar-nav ml-auto"))
                                     (li ((class "nav-item"))
                                         (a ([href ,(embed/url start)][class "nav-link js-scroll-trigger"])
                                            ,"INICIO"))
                                     (li ((class "nav-item"))
                                         (a ([href ,"#top10"][class "nav-link js-scroll-trigger"])
                                            ,"TOP 10"))
                                     (li ((class "nav-item"))
                                         (a ([href ,(embed/url heuristica)][class "nav-link js-scroll-trigger"])
                                            ,"SOLVE"))
                                     (li ((class "nav-item"))
                                         (a ([href ,(embed/url treinar)][class "nav-link js-scroll-trigger"])
                                            ,"TREINAR"))
                                     (li ((class "nav-item"))
                                         (a ([href ,(embed/url help)][class "nav-link js-scroll-trigger"])
                                            ,"HELP"))))))

                  ;header
                  (header ((class "masthead"))
                          (div ((class"intro-body"))
                               (div ((class "container"))
                                    (div ((class "row"))
                                         (div ((class "col-lg-8 mx-auto"))
                                              (h1 ((class "brand-heading"))
                                                  "8-PUZZLE")
                                              (form 
                                               ((action
                                                 ,(embed/url init-play-handler)) (class "form-group row"))
                                               (div ((class "col-2")))
                                               (div ((class "col-6"))
                                                    (input ([class "form-control tamanho"] [name "nickname"] [placeholder "nickname"]
                                                                                           [max-length "29"])))
                                               (div ((class "col-2"))
                                                    (input ([type "submit"] [value "Jogar"] [class "btn btn-default btn-lg tamanho"])))
                                               (div ((class "col-2")))))))))
             
                 ;load-users
                  (section ([id "top10"] [class "content-section text-center"])
                           (div ([class "container"])
                                (div ([class "row"])
                                     (div ([class "col-lg-8 mx-auto"])
                                          (h2 ([class "titulo"]) "TOP 10")
                                          (table ([class "table"])
                                                 (thead
                                                  (tr
                                                   (th "#")
                                                   (th "NICKNAME")
                                                   (th "SCORE")))
                                                 ,(render-as-itemized-list lista)))))))
            ;script
            (script ((type "text/javascript")
                     (src "/vendor/jquery/jquery.min.js")))
            (script ((type "text/javascript")
                     (src "/vendor/bootstrap/js/bootstrap.bundle.min.js")))
            (script ((type "text/javascript")
                     (src "/vendor/jquery-easing/jquery.easing.min.js")))
            (script ((type "text/javascript")
                     (src "/js/grayscale.min.js"))))))
  ;;chama página de jogo (top10)
  (define (init-play-handler request)
    (show-play (parse-nickname (request-bindings request)) (redirect/get)))
  ;;exibir usuários top10 na tela
  (define (render-as-itemized-list fragments)
    `(tbody ,@(map render-as-item fragments)))
  (define index 0)
  (define (render-as-item a-fragment)
    (set! index (+ index 1))
    (cond
      [(empty? a-fragment) empty]
      [else `(tr
              (th ([scope "row"]) ,(number->string index))
              (td ,(user-nickname a-fragment))
              (td ,(number->string (user-score a-fragment))))]))
  
  (send/suspend/dispatch response-generator))
;;define página de jogo (top10)
(define (show-play nickname request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html (head (title "8-PUZZLE")
            (link ((rel "stylesheet")
                         (href "https://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "https://fonts.googleapis.com/css?family=Cabin:700")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "/css/tabuleiro_screen.css")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "/css/tabuleiro.css")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "/css/grayscale.min.css")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "/css/nav.css")
                         (type "text/css"))))
            (body
             ;nav
             (nav ([class "navbar navbar-expand-lg navbar-light fixed-top"] [id "mainNav"])
                  (div ((class "container"))
                       (div ([class "collapse navbar-collapse"][id "navbarResponsive"])
                            (ul ((class "navbar-nav ml-auto"))
                                (li ((class "nav-item"))
                                    (a ([href ,(embed/url start)][class "nav-link js-scroll-trigger"])
                                       ,"INICIO"))))))
             ;conteudo
             (div ([id "conteudo"])
              (h1 ([class "score"]) "SCORE 0 ")
              (div ([id "container"] [class "tabuleiro"])            
                   (div ([id "n1"] [class "tile"] [data-value "1"]))
                   (div ([id "n2"] [class "tile"] [data-value "2"]))
                   (div ([id "n3"] [class "tile"] [data-value "3"]))
                   (div ([id "n4"] [class "tile"] [data-value "4"]))
                   (div ([id "n5"] [class "tile"] [data-value "5"]))
                   (div ([id "n6"] [class "tile"] [data-value "6"]))
                   (div ([id "n7"] [class "tile"] [data-value "7"]))
                   (div ([id "n8"] [class "tile"] [data-value "8"]))
                   (div ([id "level1Screen"] [class "tabuleiro modal"]))
                   (div ([id "level2Screen"] [class "tabuleiro modal"]))
                   (div ([id "level3Screen"] [class "tabuleiro modal"]))
                   (div ([id "level4Screen"] [class "tabuleiro modal"]))
                   (div ([id "level5Screen"] [class "tabuleiro modal"]))
                   (div ([id "endScreen"] [class "tabuleiro modal"]))))
             
             ;form com nickname e score
             (div (form ((action ,(embed/url init-play-handler)) (class "form-group row usernew"))
                        (input ([class "scoreHidden"] [type "hidden"] [name "score"]    [value "0"]))
                        (input ([class "nickname"]    [type "hidden"] [name "nickname"] [value ,nickname]))))
             (div ([class "level-1"] [data-value ,(string-join (map ~a level-1) " ")]))
             (div ([class "level-2"] [data-value ,(string-join (map ~a level-2) " ")]))
             (div ([class "level-3"] [data-value ,(string-join (map ~a level-3) " ")]))
             (div ([class "level-4"] [data-value ,(string-join (map ~a level-4) " ")]))
             (div ([class "level-5"] [data-value ,(string-join (map ~a level-5) " ")]))
             ;script
             (script ((type "text/javascript")
                       (src "/js/tabuleiro.js")))
             (script ((type "text/javascript")
                       (src "/vendor/jquery/jquery.min.js")))))))

  (define (parse-score bindings)
    (extract-binding/single 'score bindings))
  
  (define (init-play-handler request)
    (define campos (string-append "'" (parse-nickname (request-bindings request)) "'" "," "'" (parse-score (request-bindings request)) "'"))
    (define query(string-append (string-append "INSERT INTO users(nickname, score) VALUES ("campos)")"))
    (query-exec pgc query)
    (define u(user 1 (parse-nickname (request-bindings request)) (parse-score (request-bindings request))))
    (load-users-2)
    (start request))
  
  (send/suspend/dispatch response-generator))

;;define página solve/heurística
(define (show-h request)
  (define board (new-board)) ;;sorteia um tabuleiro
  (define (response-generator embed/url)
    (response/xexpr
     `(html (head (title "8-PUZZLE")
                  (link ((rel "stylesheet")
                         (href "https://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "https://fonts.googleapis.com/css?family=Cabin:700")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "/css/tabuleiro_screen.css")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "/css/grayscale.min.css")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "/css/nav.css")
                         (type "text/css"))))
            (body
             ;nav
             (nav ([class "navbar navbar-expand-lg navbar-light fixed-top"] [id "mainNav"])
                  (div ((class "container"))
                       (div ([class "collapse navbar-collapse"][id "navbarResponsive"])
                            (ul ((class "navbar-nav ml-auto"))
                                (li ((class "nav-item"))
                                    (a ([href ,(embed/url start)][class "nav-link js-scroll-trigger"])
                                       ,"INICIO"))))))
             
             (div ([id "conteudo"])
              (h1 ([class "showSolve"]) "#")
              (div ([id "container"] [class "tabuleiro"])            
                   (div ([id "n1"] [class "tile"] [data-value "1"]))
                   (div ([id "n2"] [class "tile"] [data-value "2"]))
                   (div ([id "n3"] [class "tile"] [data-value "3"]))
                   (div ([id "n4"] [class "tile"] [data-value "4"]))
                   (div ([id "n5"] [class "tile"] [data-value "5"]))
                   (div ([id "n6"] [class "tile"] [data-value "6"]))
                   (div ([id "n7"] [class "tile"] [data-value "7"]))
                   (div ([id "n8"] [class "tile"] [data-value "8"]))
                   (div ([id "startScreen"] [class "tabuleiro modal"]))
                   (div ([id "endScreen"] [class "tabuleiro modal"]))))
             
             (div
              (div ([class "initBoard"] [data-value ,(string-join (map ~a board) " ")]))
              (div ([class "solveBoard"] [data-value ,(string-join (map ~a (a-star board)) " ")])))
              
             ;script
             (script ((type "text/javascript")
                       (src "/vendor/jquery/jquery.min.js")))
             (script ((type "text/javascript")
                       (src "/js/heuristica.js")))
             ))))
  
  (send/suspend/dispatch response-generator))

;;define página treinar
(define (show-treinar request)
  (define board (new-board)) ;;sorteia um tabuleiro
  (define (response-generator embed/url)
    (response/xexpr
     `(html (head (title "8-PUZZLE")
                  (link ((rel "stylesheet")
                         (href "https://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "https://fonts.googleapis.com/css?family=Cabin:700")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "/css/tabuleiro_screen.css")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "/css/grayscale.min.css")
                         (type "text/css")))
                  (link ((rel "stylesheet")
                         (href "/css/nav.css")
                         (type "text/css"))))
            (body
             ;nav
             (nav ([class "navbar navbar-expand-lg navbar-light fixed-top"] [id "mainNav"])
                  (div ((class "container"))
                       (div ([class "collapse navbar-collapse"][id "navbarResponsive"])
                            (ul ((class "navbar-nav ml-auto"))
                                (li ((class "nav-item"))
                                    (a ([href ,(embed/url start)][class "nav-link js-scroll-trigger"])
                                       ,"INICIO"))))))
             
             (div ([id "conteudo"])
              (div ([id "container"] [class "tabuleiro"])            
                   (div ([id "n1"] [class "tile"] [data-value "1"]))
                   (div ([id "n2"] [class "tile"] [data-value "2"]))
                   (div ([id "n3"] [class "tile"] [data-value "3"]))
                   (div ([id "n4"] [class "tile"] [data-value "4"]))
                   (div ([id "n5"] [class "tile"] [data-value "5"]))
                   (div ([id "n6"] [class "tile"] [data-value "6"]))
                   (div ([id "n7"] [class "tile"] [data-value "7"]))
                   (div ([id "n8"] [class "tile"] [data-value "8"]))
                   (div ([id "startScreen"] [class "tabuleiro modal"]))
                   (div ([id "endScreen2"] [class "tabuleiro modal"]))))
             (div
              (div ([class "initBoard"] [data-value ,(string-join (map ~a (list 1 2 3 4 5 6 7 8 0)) " ")])))
             ;script
             (script ((type "text/javascript")
                       (src "/vendor/jquery/jquery.min.js")))
             (script ((type "text/javascript")
                       (src "/js/treinar.js")))
             ))))
  
  (send/suspend/dispatch response-generator))

(define (show-help request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html (head (title "8-PUZZLE"))
            (link ((rel "stylesheet")
                   (href "/vendor/bootstrap/css/bootstrap.min.css")
                   (type "text/css")))
            (link ((rel "stylesheet")
                   (href "/vendor/font-awesome/css/font-awesome.min.css")
                   (type "text/css")))
            (link ((rel "stylesheet")
                   (href "https://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic")
                   (type "text/css")))
            (link ((rel "stylesheet")
                   (href "https://fonts.googleapis.com/css?family=Cabin:700")
                   (type "text/css")))
            (link ((rel "stylesheet")
                   (href "/css/grayscale.min.css")
                   (type "text/css")))
            (link ((rel "stylesheet")
                   (href "/css/tamanho.css")
                   (type "text/css")))
            (body ([id "page-top"])
                  ;nav
                  (nav ([class "navbar navbar-expand-lg navbar-light fixed-top"] [id "mainNav"])
                       (div ((class "container"))
                            (div ([class "collapse navbar-collapse"][id "navbarResponsive"])
                                 (ul ((class "navbar-nav ml-auto"))
                                     (li ((class "nav-item"))
                                         (a ([href ,(embed/url start)][class "nav-link js-scroll-trigger"])
                                            ,"INICIO"))
                                     (li ((class "nav-item"))
                                         (a ([href ,(embed/url heuristica)][class "nav-link js-scroll-trigger"])
                                            ,"SOLVE"))
                                     (li ((class "nav-item"))
                                         (a ([href ,(embed/url treinar)][class "nav-link js-scroll-trigger"])
                                            ,"TREINAR"))
                                     (li ((class "nav-item"))
                                         (a ([href ,(embed/url help)][class "nav-link js-scroll-trigger"])
                                            ,"HELP"))))))
                  (section ([id "top10"] [class "content-section text-center"])
                           (div ([class "container"])
                                (div ([class "row"])
                                     (div ([class "col-lg-8 mx-auto"])
                                          (h2 ([class "titulo"]) "TREINAR")
                                          (p "Modo onde o jogador pode ficar resolvendo tabuleiros aleatórios para treinar."))
                                     (div ([class "col-lg-8 mx-auto"])
                                          (h2 ([class "titulo"]) "TOP10")
                                          (p "Modo onde o jogador terá que resolver 5 tabuleiros e entrará no TOP 10 se for um dos
jogadores com menor score. O score é a soma dos movimentos que o jogador realizou. Para entrar nesse modo basta colocar o
nickname na página inicial e clicar em jogar."))
                                     (div ([class "col-lg-8 mx-auto"])
                                          (h2 ([class "titulo"]) "SOLVE")
                                          (p "Modo onde o jogo ajudará o jogador resolver tabuleiros com a menor quantidade de
movimentos possíveis..")))))
                  )
            ;script
             (script ((type "text/javascript")
                       (src "/vendor/jquery/jquery.min.js")))
             (script ((type "text/javascript")
                       (src "/vendor/bootstrap/js/bootstrap.bundle.min.js")))
             (script ((type "text/javascript")
                       (src "/vendor/jquery-easing/jquery.easing.min.js")))
             (script ((type "text/javascript")
                       (src "/js/grayscale.min.js"))))))
  ;;chama página de jogo (top10)
  (define (init-play-handler request)
    (show-play (parse-nickname (request-bindings request)) (redirect/get)))
  ;;exibir usuários top10 na tela
  (define (render-as-itemized-list fragments)
    `(tbody ,@(map render-as-item fragments)))
  (define index 0)
  (define (render-as-item a-fragment)
    (set! index (+ index 1))
    (cond
      [(empty? a-fragment) empty]
      [else `(tr
              (th ([scope "row"]) ,(number->string index))
              (td ,(user-nickname a-fragment))
              (td ,(number->string (user-score a-fragment))))]))
  
  (send/suspend/dispatch response-generator))
;#####################
;#     testes        #
;#####################
(define index->coordinates-tests
  (test-suite
   "index->coordinates tests"
   (check-equal? (index->coordinates 0)(list 0 0))
   (check-equal? (index->coordinates 1)(list 0 1))
   (check-equal? (index->coordinates 2)(list 0 2))
   (check-equal? (index->coordinates 3)(list 1 0))
   (check-equal? (index->coordinates 4)(list 1 1))
   (check-equal? (index->coordinates 5)(list 1 2))
   (check-equal? (index->coordinates 6)(list 2 0))
   (check-equal? (index->coordinates 7)(list 2 1))
   (check-equal? (index->coordinates 8)(list 2 2))))

(define coordinates->index-tests
  (test-suite
   "coordinates->index tests"
   (check-equal? (coordinates->index (list 0 0)) 0)
   (check-equal? (coordinates->index (list 0 1)) 1)
   (check-equal? (coordinates->index (list 0 2)) 2)
   (check-equal? (coordinates->index (list 1 0)) 3)
   (check-equal? (coordinates->index (list 1 1)) 4)
   (check-equal? (coordinates->index (list 1 2)) 5)
   (check-equal? (coordinates->index (list 2 0)) 6)
   (check-equal? (coordinates->index (list 2 1)) 7)
   (check-equal? (coordinates->index (list 2 2)) 8)))

(define index->tile-tests
  (test-suite
   "index->tile tests"
   (check-equal? (index->tile (list 0 1 2 4 7 5 6 8) 0) 0)
   (check-equal? (index->tile (list 0 1 2 4 7 5 6 8) 7) 8)
   (check-equal? (index->tile (list 1 0 8 4 7 5 6 2) 5) 5)))

(define coordinates->tile-tests
  (test-suite
   "coordinates->tile tests"
   (check-equal? (coordinates->tile (list 0 1 2 3 4 5 6 7 8) (list 0 0)) 0)
   (check-equal? (coordinates->tile (list 0 1 2 3 4 5 6 7 8) (list 2 0)) 6)))

(define tile->index-tests
  (test-suite
   "tile->index tests"
   (check-equal? (tile->index (list 0 1 2 4 7 5 6 8 3) 0) 0)
   (check-equal? (tile->index (list 8 2 1 7 4 5 6 0 3) 6) 6)
   (check-equal? (tile->index (list 8 2 1 7 4 5 0 3 6) 2) 1)))

(define tile->coordinates-tests
  (test-suite
   "tile->coordinates tests"
   (check-equal? (tile->coordinates (list 0 1 2 4 7 5 6 8 3) 8) (list 2 1))
   (check-equal? (tile->coordinates (list 8 1 2 4 7 5 6 0 3) 4) (list 1 0))
   (check-equal? (tile->coordinates (list 6 1 2 4 7 5 0 8 3) 1) (list 0 1))))

(define valid-coordinates?-tests
  (test-suite
   "valid-coordinates? tests"
   (check-equal? (valid-coordinates? (list(list 0 1) 'DOWN)) #t)
   (check-equal? (valid-coordinates? (list(list 2 3) 'UP)) #f)
   (check-equal? (valid-coordinates? (list(list 5 1) 'RIGHT)) #f)
   (check-equal? (valid-coordinates? (list(list 2 1) 'DOWN)) #t)))

(define coordinates-swap-tests
  (test-suite
   "coordinates-swap tests"
   (check-equal? (coordinates-swap (list 0 1)) (list (list (list 1 1) 'DOWN)
                                                     (list (list 0 0) 'LEFT)
                                                     (list (list 0 2) 'RIGHT)))
   (check-equal? (coordinates-swap (list 0 0)) (list (list (list 1 0) 'DOWN)
                                                     (list (list 0 1) 'RIGHT)))
   (check-equal? (coordinates-swap (list 1 1)) (list (list (list 0 1) 'UP)
                                                     (list (list 2 1) 'DOWN)
                                                     (list (list 1 0) 'LEFT)
                                                     (list (list 1 2) 'RIGHT)))))

(define goal?-tests
  (test-suite
   "goal? tests"
   (check-equal? (goal? (list 1 2 3 4 5 6 7 8 0)) #t)
   (check-equal? (goal? (list 1 2 3 4 5 6 7 0 8)) #f)
   (check-equal? (goal? (list 3 1 2 0 5 7 6 8 4)) #f)))

(define h1-tests
  (test-suite
   "h1 tests"
   (check-equal? (h1 (list 6 4 2 1 5 3 7 0 8)) 6)
   (check-equal? (h1 (list 0 2 5 1 8 3 7 4 6)) 6)
   (check-equal? (h1 (list 8 0 7 6 5 4 3 2 1)) 7)
   (check-equal? (h1 (list 8 3 2 5 1 0 7 4 6)) 7)))

(define h2-tests
  (test-suite
   "h2 tests"
   (check-equal? (h2 (list 6 4 2 1 5 3 7 0 8)) 9)
   (check-equal? (h2 (list 0 2 5 1 8 3 7 4 6)) 8)
   (check-equal? (h2 (list 8 0 7 6 5 4 3 2 1)) 21)
   (check-equal? (h2 (list 8 3 2 5 1 0 7 4 6)) 11)
   (check-equal? (h2 (list 6 4 7 8 5 0 3 2 1)) 21)))

(define make-node-tests
  (test-suite
   "make-node tests"
   (check-equal? (make-node (list 6 4 2 1 5 3 7 0 8)
                            (node (list 6 4 2 1 5 3 7 8 0) 0 empty 'UP 9) 'LEFT)
                 (node (list 6 4 2 1 5 3 7 0 8)
                 1
                 (node (list 6 4 2 1 5 3 7 8 0) 0 empty 'UP 9)
                 'LEFT
                 9))))

(define swap-tile-tests
  (test-suite
   "swap-tile board"
  (check-equal? (swap-tile (list 6 4 7 8 5 0 3 2 1) 0 5) (list 6 4 7 8 0 5 3 2 1))
  (check-equal? (swap-tile (list 0 2 5 1 8 3 7 4 6) 6 0) (list 6 2 5 1 8 3 7 4 0))
  (check-equal? (swap-tile (list 8 3 2 5 1 0 7 4 6) 7 4) (list 8 3 2 5 1 0 4 7 6))
  (check-equal? (swap-tile (list 6 4 7 8 5 0 3 2 1) 8 1) (list 6 4 7 1 5 0 3 2 8))
  (check-equal? (swap-tile (list 6 4 7 8 5 0 3 1 2) 0 2) (list 6 4 7 8 5 2 3 1 0))))

(define get-children-tests
  (test-suite
   "get-children tests"
  (check-equal? (get-children (list 6 4 7 8 5 0 3 2 1)) (list (list (list 6 4 0 8 5 7 3 2 1) 'UP)
                                                              (list (list 6 4 7 8 5 1 3 2 0) 'DOWN)
                                                              (list (list 6 4 7 8 0 5 3 2 1) 'LEFT)))
  (check-equal? (get-children (list 0 2 5 1 8 3 7 4 6)) (list (list (list 1 2 5 0 8 3 7 4 6) 'DOWN)
                                                              (list (list 2 0 5 1 8 3 7 4 6) 'RIGHT)))
  (check-equal? (get-children (list 8 0 7 6 5 4 3 2 1)) (list (list (list 8 5 7 6 0 4 3 2 1) 'DOWN)
                                                              (list (list 0 8 7 6 5 4 3 2 1) 'LEFT)
                                                              (list (list 8 7 0 6 5 4 3 2 1) 'RIGHT)))))

(define node-father-board-tests
  (test-suite
   "node-father-board tests"
   (check-equal? (node-father-board (node (list 1 2 3 4 5 6 7 8 0) 1
                                          (node (list 1 2 3 4 5 6 7 0 8) 0 empty 'UP 1)
                                          'RIGHT 0)) (list 1 2 3 4 5 6 7 0 8))))

(define EXTRACT-tests
  (test-suite
   "EXTRACT tests"
   (check-equal? (EXTRACT (node (list 1 2 3 4 5 6 7 8 0) 0 empty 'UP 1))
                 (list
                  (node (list 1 2 3 4 5 0 7 8 6) 1 (node (list 1 2 3 4 5 6 7 8 0) 0 empty 'UP 1) 'UP 1)
                  (node (list 1 2 3 4 5 6 7 0 8) 1 (node (list 1 2 3 4 5 6 7 8 0) 0 empty 'UP 1) 'LEFT 1)))))

(define valid-tests
  (test-suite
   "valid tests"
   (check-equal? (valid 2 (list 3 4 5 0 7 8 6)) 0)))

(define valid-loop-tests
  (test-suite
   "valid-loop tests"
   (check-equal? (valid-loop (list 1 2 3 4 5 6 7 8 0)) 0)
   (check-equal? (valid-loop (list 6 4 2 1 5 3 7 0 8)) 10)))

(define valid-game-tests
  (test-suite
   "valid-game tests"
   (check-equal? (valid-game (list 1 2 3 4 5 6 7 8 0)) 0)
   (check-equal? (valid-game (list 6 4 2 1 5 3 7 0 8)) 0)
   (check-equal? (valid-game (list 3 8 2 5 1 0 7 4 6)) 1)))

(define a-start-tests
  (test-suite
   "a-star tests"
   (check-equal? (a-star (list 1 2 3 4 5 6 7 8 0))(list 'FIM))
   (check-equal? (a-star (list 8 0 7 6 5 4 3 2 1))(list 'DOWN
                                                        'DOWN
                                                        'RIGHT
                                                        'RIGHT
                                                        'UP
                                                        'UP
                                                        'LEFT
                                                        'LEFT
                                                        'DOWN
                                                        'DOWN
                                                        'RIGHT
                                                        'RIGHT
                                                        'UP
                                                        'UP
                                                        'LEFT
                                                        'LEFT
                                                        'DOWN
                                                        'DOWN
                                                        'RIGHT
                                                        'RIGHT
                                                        'UP
                                                        'UP
                                                        'LEFT
                                                        'LEFT
                                                        'DOWN
                                                        'DOWN
                                                        'RIGHT
                                                        'FIM))
   (check-equal? (a-star (list 6 4 2 1 5 3 7 0 8))(list 'RIGHT 'DOWN 'LEFT 'DOWN 'RIGHT 'UP 'RIGHT 'DOWN 'LEFT 'UP 'UP 'FIM))
   (check-equal? (a-star (list 0 2 5 1 8 3 7 4 6))(list 'RIGHT 'RIGHT 'DOWN 'DOWN 'LEFT 'UP 'UP 'LEFT 'DOWN 'DOWN 'RIGHT 'RIGHT 'UP
                                                        'LEFT 'UP 'RIGHT 'DOWN 'DOWN 'FIM))))

;(define new-board-tests
;  (test-suite
;   "new-baord tests"
;   (check-equal? (new-board) list?)))

(define (executa-testes . testes)
  (run-tests (test-suite "Todos os testes" testes))
  (void))

(executa-testes index->coordinates-tests coordinates->index-tests index->tile-tests coordinates->tile-tests
                tile->index-tests tile->coordinates-tests valid-coordinates?-tests coordinates-swap-tests goal?-tests h1-tests
                h1-tests h2-tests make-node-tests swap-tile-tests get-children-tests node-father-board-tests EXTRACT-tests
                valid-tests valid-loop-tests valid-game-tests a-start-tests)

;#####################
;#   serve/servlet   #
;#####################;
;(serve/servlet start
;               #:launch-browser? #t
;               #:quit? #t
;               #:listen-ip #f
;               #:port 8081
;               #:log-file "log"
;               #:manager
;               (make-threshold-LRU-manager #f (* 1280 1024 1024))
;               #:extra-files-paths
;               (list (build-path (current-directory) "htdocs"))
;               #:servlet-path "/xapps/")
;)
;;define local dos arquivos estáticos
(static-files-path "htdocs")