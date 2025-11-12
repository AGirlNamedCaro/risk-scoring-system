require "json"

class RiskScoringSystem
  def initialize(data)
    @data = JSON.parse(data)
  end

  def calculate_score
    credit_score = calculate_credit_score
    revenue_score = calculate_revenue_score

    { factors: {
      credit: credit_score,
      revenue: revenue_score,
    } }
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
      score: score.round,
      weight: weight,
      contribution: contribution.round(1),
    }
  end

  def calculate_revenue_score
    annual_revenue = @data["annual_revenue"]

    case annual_revenue
    when 0..999_999
      score = (annual_revenue / 10_000)
    when 1_000_000..Float::INFINITY
      score = 100
    end

    weight = 0.3
    contribution = score * weight

    {
        score: score.round,
        weight: weight,
        contribution: contribution.round(1),
    }
  end
end
