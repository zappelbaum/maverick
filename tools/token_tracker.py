#!/usr/bin/env python3
"""
Token Cost Tracker
Tracks Moonshot API usage and costs in real-time
"""

import json
import os
from datetime import datetime, timezone
from pathlib import Path

# Moonshot pricing (as of Jan 2026)
INPUT_COST_PER_1M = 0.60   # $0.60 per million input tokens
OUTPUT_COST_PER_1M = 3.00  # $3.00 per million output tokens

class TokenTracker:
    def __init__(self, budget_file="/root/.openclaw/workspace/memory/heartbeat-state.json"):
        self.budget_file = budget_file
        self.session_start = datetime.now(timezone.utc)
        self.session_tokens_in = 0
        self.session_tokens_out = 0
        
    def load_budget(self):
        """Load current budget from tracking file"""
        try:
            with open(self.budget_file) as f:
                data = json.load(f)
                return data.get("checkResults", {}).get("cost_tracking", {})
        except:
            return {"budget_remaining": 11.0, "status": "unknown"}
    
    def calculate_cost(self, input_tokens, output_tokens):
        """Calculate cost for given token counts"""
        input_cost = (input_tokens / 1_000_000) * INPUT_COST_PER_1M
        output_cost = (output_tokens / 1_000_000) * OUTPUT_COST_PER_1M
        return input_cost + output_cost
    
    def estimate_session_cost(self, input_tokens, output_tokens):
        """Estimate cost for current session activity"""
        return self.calculate_cost(input_tokens, output_tokens)
    
    def get_burn_rate(self, hours_active):
        """Calculate hourly burn rate"""
        budget_data = self.load_budget()
        remaining = budget_data.get("budget_remaining", 11.0)
        # Rough estimate based on typical usage patterns
        return {
            "conservative": 0.50,
            "balanced": 0.75,
            "liberal": 1.00
        }
    
    def runway_hours(self, budget_remaining, hourly_rate):
        """Calculate remaining hours at given burn rate"""
        return budget_remaining / hourly_rate
    
    def status_report(self):
        """Generate current status report"""
        budget = self.load_budget()
        remaining = budget.get("budget_remaining", 11.0)
        
        hours_at_balanced = self.runway_hours(remaining, 0.75)
        hours_at_conservative = self.runway_hours(remaining, 0.50)
        
        return {
            "budget_remaining": remaining,
            "runway_balanced_hours": round(hours_at_balanced, 1),
            "runway_conservative_hours": round(hours_at_conservative, 1),
            "recommended_mode": "balanced" if remaining > 5 else "conservative",
            "timestamp": datetime.now(timezone.utc).isoformat()
        }

if __name__ == "__main__":
    tracker = TokenTracker()
    report = tracker.status_report()
    print(json.dumps(report, indent=2))
