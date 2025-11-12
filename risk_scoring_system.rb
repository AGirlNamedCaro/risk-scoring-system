require 'json'
class RiskScoringSystem
    def initialize(data)
        @data = JSON.parse(data)
    end

    def calculate_score
        credit_score = calculate_credit_score
    end

    private

    def calculate_credit_score
        credit_score = @data["credit_score"].to_f

        case credit_score
        when 0..300
            score = 0
        when 301..719
            score = ((credit_score - 300) / (850 - 300)) * 100
        when 720..850
            score = 100
        end

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