# Risk Scoring System

Build a risk scoring system that:
1. Takes business data (credit score, revenue, time in business, industry)
2. Calculates a risk score (0-100)
3. Returns a risk tier (Low/Medium/High)
4. Explains WHY the score was given

The catch: Scoring rules change frequently based on:
- Market conditions (conservative vs aggressive)
- Industry (restaurants are riskier than tech)
- Loan size (small vs large loans have different criteria)

### Technology
Ruby 3.4.5

#### TO DO
- Separate explanations for calculations
- Split calculate score so that it's not too big and repetitive
- Integrate multiple strategies i.e conservative, aggressive using the strategy pattern
