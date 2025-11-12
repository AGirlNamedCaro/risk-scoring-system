require 'json'
class RiskScoringSystem
    def initialize(data)
        @data = JSON.parse(data)
    end

    def calculate_score
        credit_score = calculate_credit_score
        revenue_score = calculate_revenue_score
    end

    private

    def calculate_credit_score
        credit_score = @data["credit_score"].to_f

        score = ((credit_score - 300) / (850 - 300)) * 100
        weight = 0.4
        contribution = score * weight


        {
            factors: {
                credit: {
                    score: score.round,
                    weight: weight,
                    contribution: contribution.round(1)
                }
            }
        }
    end

end