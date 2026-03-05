-- Momentum signals: compare current price to 20, 50, and 200-day moving averages
WITH moving_avgs AS (
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
)
SELECT
    ticker,
    date,
    close,
    ROUND((close - ma_20) / ma_20, 4) AS momentum_20,
    ROUND((close - ma_50) / ma_50, 4) AS momentum_50,
    ROUND((close - ma_200) / ma_200, 4) AS momentum_200,
    CASE
        WHEN close > ma_20 AND close > ma_50 AND close > ma_200 THEN 'BULLISH'
        WHEN close < ma_20 AND close < ma_50 AND close < ma_200 THEN 'BEARISH'
        ELSE 'NEUTRAL'
    END AS signal
FROM
    moving_avgs
ORDER BY
    ticker, date;