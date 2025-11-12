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
    end
end