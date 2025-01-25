;; Government Integration Contract

(define-map feasibility-checks uint {
    project-id: uint,
    status: (string-ascii 20),
    notes: (string-utf8 500),
    checked-by: principal,
    timestamp: uint
})

(define-map implementation-updates uint {
    project-id: uint,
    status: (string-ascii 20),
    notes: (string-utf8 500),
    updated-by: principal,
    timestamp: uint
})

(define-data-var government-authority principal tx-sender)

(define-public (set-government-authority (new-authority principal))
    (begin
        (asserts! (is-eq tx-sender (var-get government-authority)) (err u403))
        (ok (var-set government-authority new-authority))
    )
)

(define-public (submit-feasibility-check (project-id uint) (status (string-ascii 20)) (notes (string-utf8 500)))
    (begin
        (asserts! (is-eq tx-sender (var-get government-authority)) (err u403))
        (map-set feasibility-checks project-id {
            project-id: project-id,
            status: status,
            notes: notes,
            checked-by: tx-sender,
            timestamp: block-height
        })
        (ok true)
    )
)

(define-public (submit-implementation-update (project-id uint) (status (string-ascii 20)) (notes (string-utf8 500)))
    (begin
        (asserts! (is-eq tx-sender (var-get government-authority)) (err u403))
        (map-set implementation-updates project-id {
            project-id: project-id,
            status: status,
            notes: notes,
            updated-by: tx-sender,
            timestamp: block-height
        })
        (ok true)
    )
)

(define-read-only (get-feasibility-check (project-id uint))
    (map-get? feasibility-checks project-id)
)

(define-read-only (get-implementation-update (project-id uint))
    (map-get? implementation-updates project-id)
)

