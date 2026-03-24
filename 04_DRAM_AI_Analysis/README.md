README
# DRAM Pricing Boom Analysis

Challenging the current narrative that OpenAI is to blame 
for the historical price increase we've seen with DRAM.

## Background

OpenAI is without a doubt the most talked about AI tool on 
the market, making it the easiest target for scrutiny. When 
DRAM prices hit a historical level, OpenAI was the natural 
go-to for blame because it had been the most consumer facing 
LLM. I do not believe proximity is a measurement of 
correlation. I believe that correlation is a measurement 
for correlation.

## Data Sources

- **SEC EDGAR 10-K filings** — Amazon, Microsoft, 
Alphabet/Google, Meta — 2020 through 2025
- **DRAM Pricing** — TrendForce, Tom's Hardware, 
PCPartPicker, GamersNexus, DRAMeXchange, Amazon/Newegg
- **Contract Pricing** — Samsung and TrendForce

## Methodology

Capex figures were pulled from the Purchases of Property 
and Equipment line on the cash flow statement for all four 
companies. Python was used to clean the comprehensive and 
enterprise datasets, specifically to sort market types into 
three categories and calculate the midpoint price per GB. 
Power BI was used for data visualization, illustrating the 
overall trend in a digestible way without having to comb 
over the raw datasets.

## Findings

Amazon's infrastructure capex increased dramatically in 
2023-2024, predating the DRAM price shock by approximately 
two to three quarters. Retail and contract DRAM prices 
remained relatively stable through 2024 despite this 
spending increase, suggesting the initial demand was 
absorbed by existing supply. When AWS accelerated to $128B 
in 2025, it was joined by parallel increases from Microsoft, 
Google, and Meta and the supply buffer was exhausted. Spot 
prices spiked first in Q2 2025, followed by contract and 
retail prices reaching historic highs by Q4 2025.

This timing sequence suggests hyperscaler infrastructure 
investment, particularly Amazon's, was a leading indicator 
of DRAM market disruption rather than a lagging response 
to it. The public narrative attributing this pressure to 
OpenAI misidentifies the mechanism. OpenAI operates 
entirely on Microsoft's infrastructure and owns no physical 
compute assets.

## Limitations

This analysis demonstrates correlation and timing patterns, 
not proven causation. Additional factors contributed to the 
supply shock, including HBM capacity reallocation away from 
consumer DRAM toward AI accelerators. This analysis 
captures the demand side but not the complete supply 
side picture.