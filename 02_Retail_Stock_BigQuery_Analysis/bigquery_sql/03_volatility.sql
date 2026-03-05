-- Annualized volatility (30-day rolling) for each stock
WITH daily_returns AS (
    SELECT
        ticker,
        date,
        LN(close / LAG(close) OVER (
            PARTITION BY ticker
            ORDER BY date
        )) AS log_return
    FROM
        `my-data-project-488902.market_movers.prices_raw`
)
SELECT
    ticker,
    date,
    ROUND(
        STDDEV(log_return) OVER (
            PARTITION BY ticker
            ORDER BY date
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) * SQRT(252), 6
    ) AS annualized_volatility
FROM
    daily_returns
WHERE
    log_return IS NOT NULL
ORDER BY
    ticker, date;