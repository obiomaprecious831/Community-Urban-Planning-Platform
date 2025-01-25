;; Fund Allocation Contract

(define-map project-funds uint uint)
(define-map project-status uint (string-ascii 20))

(define-public (contribute-funds (project-id uint) (amount uint))
    (let
        ((current-status (default-to "proposed" (map-get? project-status project-id))))
        (asserts! (is-some (map-get? project-funds project-id)) (err u404))
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set project-funds project-id
            (+ (default-to u0 (map-get? project-funds project-id)) amount))
        (ok true)
    )
)

(define-public (withdraw-funds (project-id uint) (amount uint))
    (let
        ((current-funds (default-to u0 (map-get? project-funds project-id))))
        (asserts! (> current-funds u0) (err u404))
        (asserts! (<= amount current-funds) (err u401))
        (try! (as-contract (stx-transfer? amount tx-sender tx-sender)))
        (map-set project-funds project-id (- current-funds amount))
        (ok true)
    )
)

(define-public (set-project-status (project-id uint) (status (string-ascii 20)))
    (begin
        (map-set project-status project-id status)
        (ok true)
    )
)

(define-read-only (get-project-funds (project-id uint))
    (ok (default-to u0 (map-get? project-funds project-id)))
)

(define-read-only (get-project-status (project-id uint))
    (ok (default-to "proposed" (map-get? project-status project-id)))
)

