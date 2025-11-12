require_relative "test_helper"
require_relative "../risk_scoring_system"
$stdout.sync = true

class RiskScoringSystemTest < Minitest::Test
    def test_scoring_calculation
        data = File.read("test/fixtures/credit_data.json")
        
        risk_assessment = RiskScoringSystem.new(data).calculate_score

        assert_equal 69, risk_assessment[:factors][:credit][:score]
        assert_equal 0.4, risk_assessment[:factors][:credit][:weight]
        assert_equal 27.6, risk_assessment[:factors][:credit][:contribution]
        assert_equal 50, risk_assessment[:factors][:revenue][:score]
        assert_equal 0.3, risk_assessment[:factors][:revenue][:weight]
        assert_equal 15.0, risk_assessment[:factors][:revenue][:contribution]
        assert_equal 60, risk_assessment[:factors][:longevity][:score]
        assert_equal 0.3, risk_assessment[:factors][:longevity][:weight]
        assert_equal 18.0, risk_assessment[:factors][:longevity][:contribution]
        assert_equal 60.6, risk_assessment[:score]
        assert_equal "Medium Risk", risk_assessment[:tier]
        assert_equal 3, risk_assessment[:explanation].size
        assert_equal "Credit score below preferred threshold (69 vs 720+)", risk_assessment[:explanation][0]
        assert_equal "Annual revenue meets minimum requirements", risk_assessment[:explanation][1]
        assert_equal "Business longevity meets minimum requirements (36 months)", risk_assessment[:explanation][2] 
    end
end