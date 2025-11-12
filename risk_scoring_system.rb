require "json"

class RiskScoringSystem
  RISK_TIERS = {
    80..100 => "Low Risk",
    50..79 => "Medium Risk",
    0..49 => "High Risk",
  }

  def initialize(data)
    @data = JSON.parse(data)
  end

  def calculate_score
    credit_score = calculate_credit_score
    credit_explanation = credit_score[:explanation] && credit_score.delete(:explanation)
    revenue_score = calculate_revenue_score
    revenue_explanation = revenue_score[:explanation] && revenue_score.delete(:explanation)
    longevity_score = calculate_longevity_score
    longevity_explanation = longevity_score[:explanation] && longevity_score.delete(:explanation)
    overall_score = calculate_overall_score(credit_score[:contribution], revenue_score[:contribution], longevity_score[:contribution])
    tier = get_tier(overall_score)

    {
      score: overall_score.round(1),
      tier: tier,
      factors: {
        credit: credit_score,
        revenue: revenue_score,
        longevity: longevity_score,
      },
      explanation: [credit_explanation, revenue_explanation, longevity_explanation],
    }
  end

  private

  def calculate_credit_score
    credit_score = @data["credit_score"].to_f

    case credit_score
    when 0..300
      score = 0
      explanation = "Credit score is too low"
    when 301..719
      score = ((credit_score - 300) / (850 - 300)) * 100
      explanation = "Credit score below preferred threshold (#{score.round} vs 720+)"
    when 720..850
      score = 100
      explanation = "Excellent credit score"
    end

    weight = 0.4
    contribution = score * weight

    {
      score: score.round,
      weight: weight,
      contribution: contribution.round(1),
      explanation: explanation,
    }
  end

  def calculate_revenue_score
    annual_revenue = @data["annual_revenue"]

    case annual_revenue
    when 0..999_999
      score = (annual_revenue / 10_000)
      if score < 50
        explanation = "Annual revenue below preferred threshold"
      else
        explanation = "Annual revenue meets minimum requirements"
      end
    when 1_000_000..Float::INFINITY
      score = 100
      explanation = "Strong annual revenue"
    end

    weight = 0.3
    contribution = score * weight

    {
      score: score.round,
      weight: weight,
      contribution: contribution.round(1),
      explanation: explanation,
    }
  end

  def calculate_longevity_score
    months_in_business = @data["months_in_business"].to_f

    case months_in_business
    when 0..36
      score = (months_in_business / 60) * 100
      if score < 33
        explanation = "New business with limited longevity (#{months_in_business} months vs 12+ months preferred)"
      else
        explanation = "Business longevity meets minimum requirements (#{months_in_business.round} months)"
      end
    when 37..Float::INFINITY
      score = 100
      explanation = "Established business with strong longevity"
    end

    weight = 0.3
    contribution = score * weight

    {
      score: score.round,
      weight: weight,
      contribution: contribution.round(1),
      explanation: explanation,
    }
  end

  def calculate_overall_score(credit, revenue, longevity)
    credit + revenue + longevity
  end

  def get_tier(score)
    RISK_TIERS.each do |key, value|
      return value if key.include?(score)
    end
  end
end
