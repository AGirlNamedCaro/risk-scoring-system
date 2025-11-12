require "json"
require_relative './lib/calculation_utilities'
require_relative './lib/constants'

class RiskScoringSystem
  include CalculationUtilities

  def initialize(data)
    @data = validate_fields(JSON.parse(data))
  end

  def calculate_score
    credit_score = calculate_credit_score(@data["credit_score"].to_f)
    credit_explanation = credit_score[:explanation] && credit_score.delete(:explanation)
    revenue_score = calculate_revenue_score(@data["annual_revenue"].to_f)
    revenue_explanation = revenue_score[:explanation] && revenue_score.delete(:explanation)
    longevity_score = calculate_longevity_score(@data["months_in_business"].to_f)
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

  def get_tier(score)
    RISK_TIERS.each do |key, value|
      return value if key.include?(score)
    end
  end

  def validate_fields(parsed_data)
    data = parsed_data.transform_keys(&:to_sym)

    required_fields = %i[
      credit_score
      annual_revenue
      months_in_business
      industry
    ]

    missing_fields = required_fields.select { |field| data[field].nil? || data[field].to_s.strip.empty? }

    unless missing_fields.empty?
      raise ArgumentError, "Missing required fields: #{missing_fields.join(", ")}"
    end
    parsed_data
  end
end
