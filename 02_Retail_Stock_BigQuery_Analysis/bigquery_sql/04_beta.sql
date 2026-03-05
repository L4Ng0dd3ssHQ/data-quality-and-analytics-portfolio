-- Beta vs S&P 500 (SPY) for each stock
WITH returns AS (
    SELECT
        p.ticker,
        p.date,
        LN(p.close / LAG(p.close) OVER (
            PARTITION BY p.ticker
            ORDER BY p.date
        )) AS stock_return,
        LN(s.close / LAG(s.close) OVER (
            ORDER BY s.date
        )) AS market_return
    FROM
        `my-data-project-488902.market_movers.prices_raw` p
    JOIN
        `my-data-project-488902.market_movers.index_prices` s
        ON p.date = s.date
)
SELECT
    ticker,
    ROUND(
        COVAR_SAMP(stock_return, market_return) /
        VAR_SAMP(market_return),
    4) AS beta
FROM
    returns
WHERE
    stock_return IS NOT NULL
    AND market_return IS NOT NULL
GROUP BY
    ticker
ORDER BY
    ticker;