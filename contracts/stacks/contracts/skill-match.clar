;; SkillMatch - Decentralized freelancer marketplace
(define-constant ERR-JOB-TAKEN (err u100))
(define-constant ERR-NOT-FREELANCER (err u101))

(define-map jobs
    { job-id: uint }
    { client: principal, description: (string-ascii 256), budget: uint, freelancer: (optional principal), completed: bool, paid: bool }
)

(define-map skills { user: principal, skill-index: uint } { skill: (buff 32) })
(define-data-var job-counter uint u0)

(define-public (post-job (description (string-ascii 256)) (budget uint))
    (let (
        (job-id (var-get job-counter))
    )
        (map-set jobs { job-id: job-id } {
            client: tx-sender,
            description: description,
            budget: budget,
            freelancer: none,
            completed: false,
            paid: false
        })
        (var-set job-counter (+ job-id u1))
        (ok job-id)
    )
)

(define-public (accept-job (job-id uint))
    (let (
        (job (unwrap! (map-get? jobs { job-id: job-id }) ERR-JOB-TAKEN))
    )
        (asserts! (is-none (get freelancer job)) ERR-JOB-TAKEN)
        (map-set jobs { job-id: job-id } (merge job { freelancer: (some tx-sender) }))
        (ok true)
    )
)

(define-public (complete-job (job-id uint))
    (let (
        (job (unwrap! (map-get? jobs { job-id: job-id }) ERR-NOT-FREELANCER))
    )
        (asserts! (is-eq (get freelancer job) (some tx-sender)) ERR-NOT-FREELANCER)
        (map-set jobs { job-id: job-id } (merge job { completed: true }))
        (ok true)
    )
)

(define-read-only (get-job (job-id uint))
    (map-get? jobs { job-id: job-id })
)
