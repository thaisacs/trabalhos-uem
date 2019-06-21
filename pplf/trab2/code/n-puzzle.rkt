#lang racket

(require data/heap)

(define K 6) ;;matriz K*K
(define SIZE (- (* K K) 1))
(define T (- K 1))

(define RAM 0)

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

(define (index->coordinates index)
    (list-ref COORDINATES index))

(define (coordinates->index coordinates)
    (+ (* K (first coordinates)) (second coordinates)))

(define (index->tile board index)
    (list-ref board index))

(define (coordinates->tile board coordinates)
    (index->tile board (coordinates->index coordinates)))

(define (tile->index board tile)
    (-  (length board) (length (memv tile board))))

(define (tile->coordinates board tile)
    (index->coordinates (tile->index board tile)))

(define (valid-coordinates? coordinates-and-action)
    (list? (member (first coordinates-and-action) COORDINATES)))

(define (coordinates-swap coordinates)
  (filter valid-coordinates?
          (list
           (list (list (- (first coordinates) 1) (second coordinates)) 'UP)
           (list (list (+ (first coordinates) 1) (second coordinates)) 'DOWN)
           (list (list (first coordinates) (- (second coordinates) 1)) 'LEFT)
           (list (list (first coordinates) (+ (second coordinates) 1)) 'RIGHT))))

(struct node (board g father action h) #:transparent)

(define (node-<= v1 v2)
  (<= (node-f v1) (node-f v2)))

(define (node-f v)
    (+ (node-g v) (node-h v)))

(define (goal? board)
    (equal? GOAL board))

;heurística 1
(define (h1 n0)
  (define (loop n goal)
  (cond
    [(empty? n) 0]
    [(= 0 (first n)) (+ 0 (loop (rest n) (rest goal)))]
    [else (cond
            [(= (first n) (first goal)) (+ 0 (loop (rest n) (rest goal)))]
            [else (+ 1 (loop (rest n) (rest goal)))])]))
  (loop n0 GOAL))

;;heuristica 2
(define (h2 state)
    (apply + (flatten
               (map (lambda (i)
                      (map (lambda (j)
                             (if (eqv? 0 (list-ref state (+ (* K i) j)))
                                 0
                                 (distance (list-ref state (+ (* K i) j)) i j)))
                           (index-list T)))
                    (index-list T)))))
  
  (define (distance key x y)
    (+ (abs (- (first (list-ref COORDINATES (- key 1))) x))
       (abs (- (second (list-ref COORDINATES (- key 1))) y))))

(define (make-node board father action)
  (node board     
        (if (eq? empty father) 0 (+ 1 (node-g father)))
        father
        action
        (h2 board)))

(define (swap-tile board source tile)
    (map (lambda (tile-corrent)
           (cond
             [(= tile-corrent source) tile]
             [(= tile-corrent tile) source]
             [else tile-corrent]))
         board))

(define (get-children board)
  (map (lambda (target-and-action)
         (list
          (swap-tile board 0 (coordinates->tile board (first target-and-action)))
          (second target-and-action)))
       (coordinates-swap (tile->coordinates board 0))))

(define (node-father-board node)
    (if (node? (node-father node))
        (node-board (node-father node))
        null))

(define (EXTRACT n)
  (map
     (lambda (next-board-and-action) (make-node (first next-board-and-action) n (second next-board-and-action)))
     (remove
      (node-father-board n)
      (get-children (node-board n))
      (lambda (father-board board-and-action) (equal? father-board (first board-and-action))))))

(define (get-solution n)
  (cond
    [(equal? (node-action n) 'FIM)  (list (node-action n))]
    [else (append (list(node-action n)) (get-solution (node-father n)))]))

;;a*
(define (a-star INIT)
  ;;OPEN e CLOSED
  (define OPEN (make-heap (lambda (v1 v2) (node-<= v1 v2))))
  (define CLOSED (make-hash))
  
  (heap-add! OPEN (make-node INIT empty 'FIM))
  
  (define (loop)
    (cond
      [(empty? OPEN) (error "OPEN empty")]
      [else
       (define x (heap-min OPEN))
       (heap-remove-min! OPEN)
       (cond
         ((goal? (node-board x)) (node-board x))
         (else
          (hash-set! CLOSED (node-board x) x)
          (for-each
           (lambda (y)
             (hash-ref CLOSED (node-board y) (lambda () (heap-add! OPEN y) (set! RAM (add1 RAM)))))
           (EXTRACT x))(loop)
          ))]))
  (loop)RAM)

(define (valid elem0 list-board)
  (define (loop elem list inversions)
    (cond
      [(empty? list) inversions]
      [else (if (or (= (first list) 0) (<= elem (first list)))
                (loop elem (rest list) inversions)
                (loop elem (rest list) (add1 inversions)))]))
  (loop elem0 list-board 0))

(define (valid-loop list-board)
    (cond
      [(empty? list-board) 0]
      [else (if (= 0 (first list-board))
                (valid-loop (rest list-board))
                (+ (valid (first list-board) (rest list-board)) (valid-loop (rest list-board))))]))

(define (valid-game list-board)
  (remainder (valid-loop list-board) 2))

(define (random-board new-list size)
  (cond
    [(= size (length new-list)) new-list]
    [else (define index (random size))
          (if (equal? (member index new-list) #f)
              (random-board (append new-list (list index)) size)
              (random-board new-list size))]))

(define (new-board)
  (define lista (random-board (list) (+ 1 SIZE)))
  (cond
    [(= 0 (valid-game lista)) lista]
    [else (new-board)]))

;##########################
;#   testes relatório     #
;##########################
(define 8-inst-1 (list 6 4 2 1 5 3 7 0 8))
(define 8-inst-2 (list 0 2 5 1 8 3 7 4 6))
(define 8-inst-3 (list 8 0 7 6 5 4 3 2 1))
(define 8-inst-4 (list 8 3 2 5 1 0 7 4 6))
(define 8-inst-5 (list 6 4 7 8 5 0 3 2 1))

(define 15-inst-1 (list 1 0 3 4 11 2 13 14 10 12 15 5 8 9 7 6))
(define 15-inst-2 (list 2 13 3 14 10 1 12 4 5 11 15 8 0 9 7 6))
(define 15-inst-3 (list 1 11 5 13 0 10 7 3 14 6 4 2 9 12 8 15))
(define 15-inst-4 (list 12 1 2 3 11 13 14 4 10 15 6 5 0 9 8 7))
(define 15-inst-5 (list 1 2 3 4 11 12 13 14 10 9 15 5 0 8 7 6))

(define 24-inst-1 (list 2 3 0 4 5 1 7 8 9 10 6 11 12 13 15 16 17 18 14 20 21 22 23 19 24))
(define 24-inst-2 (list 1 2 3 5 10 6 7 8 4 0 11 12 13 9 15 16 17 18 14 20 21 22 23 19 24))
(define 24-inst-3 (list 2 3 5 4 10 12 1 6 7 15 13 8 9 0 20 11 17 18 14 24 16 21 22 23 19))
(define 24-inst-4 (list 11 6 1 2 3 21 7 8 4 5 17 16 12 10 15 0 13 14 18 9 22 23 19 20 24))
(define 24-inst-5 (list 2 3 4 5 10 6 1 7 8 9 16 11 12 13 15 17 18 14 0 20 21 22 23 19 24))


(define 35-inst-1 (list 1 2 4 5 6 12 7 8 3 17 10 18 14 9 16 28 11 24 13 19 20 22 29 23 25 26 0 21 30 15 31 32 27 33 34 35))
(define 35-inst-2 (list 1 2 4 5 6 12 7 0 3 17 10 18 14 8 16 28 11 24 13 9 20 22 29 23 25 19 26 21 30 15 31 32 27 33 34 35))
(define 35-inst-3 (list 7 1 4 5 6 12 0 2 3 17 10 18 14 8 16 28 11 24 13 9 20 22 29 23 25 19 26 21 30 15 31 32 27 33 34 35))

(define S (current-inexact-milliseconds))
(a-star 35-inst-1)
(define E (current-inexact-milliseconds))
(- E S)