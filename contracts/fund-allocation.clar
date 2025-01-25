;; Fund Allocation Contract

(define-map project-funds uint uint)

(define-public (contribute-funds (project-id uint) (amount uint))
    (let
        ((project (unwrap! (contract-call? .project-proposals get-project project-id) (err u404))))
        (asserts! (is-eq (get status project) "approved") (err u403))
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set project-funds project-id
            (+ (default-to u0 (map-get? project-funds project-id)) amount))
        (ok true)
    )
)

(define-public (withdraw-funds (project-id uint) (amount uint))
    (let
        ((project (unwrap! (contract-call? .project-proposals get-project project-id) (err u404)))
         (current-funds (default-to u0 (map-get? project-funds project-id))))
        (asserts! (is-eq tx-sender (get proposer project)) (err u403))
        (asserts! (<= amount current-funds) (err u401))
        (try! (as-contract (stx-transfer? amount tx-sender (get proposer project))))
        (map-set project-funds project-id (- current-funds amount))
        (ok true)
    )
)

(define-read-only (get-project-funds (project-id uint))
    (ok (default-to u0 (map-get? project-funds project-id)))
)

