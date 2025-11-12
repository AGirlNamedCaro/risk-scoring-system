module CalculationUtilities
  def calculate_credit_score(credit_score)
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
    else
      raise ArgumentError, "Invalid argument provided."
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

  def calculate_revenue_score(annual_revenue)
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
    else
      raise ArgumentError, "Invalid argument provided."
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

  def calculate_longevity_score(months_in_business)
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
    else
      raise ArgumentError, "Invalid argument provided."
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
end
