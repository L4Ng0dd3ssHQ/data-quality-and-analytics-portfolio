-- Moving Averages: 20, 50, and 200-day for each stock
SELECT
    ticker,
    date,
    close,
    AVG(close) OVER (
        PARTITION BY ticker
        ORDER BY date
        ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
    ) AS ma_20,
    AVG(close) OVER (
        PARTITION BY ticker
        ORDER BY date
        ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
    ) AS ma_50,
    AVG(close) OVER (
        PARTITION BY ticker
        ORDER BY date
        ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
    ) AS ma_200
FROM
    `my-data-project-488902.market_movers.prices_raw`
ORDER BY
    ticker, date;