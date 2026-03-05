-- Daily returns and log returns for each stock
SELECT
    ticker,
    date,
    close,
    LAG(close) OVER (
        PARTITION BY ticker
        ORDER BY date
    ) AS prev_close,
    ROUND((close - LAG(close) OVER (
        PARTITION BY ticker
        ORDER BY date
    )) / LAG(close) OVER (
        PARTITION BY ticker
        ORDER BY date
    ), 6) AS daily_return,
    ROUND(LN(close / LAG(close) OVER (
        PARTITION BY ticker
        ORDER BY date
    )), 6) AS log_return
FROM
    `my-data-project-488902.market_movers.prices_raw`
ORDER BY
    ticker, date;