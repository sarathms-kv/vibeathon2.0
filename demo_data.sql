-- Demo Data Population Script for VibeLog Application
-- Run this script in DBeaver to populate tables with realistic demo data

-- Clear existing data (optional - uncomment if needed)
-- DELETE FROM burnoutscores;
-- DELETE FROM vibereports;
-- DELETE FROM vibelogs;
-- DELETE FROM users WHERE email != 'admin@company.com'; -- Keep admin user

-- Insert Demo Users (Employees and Admins)
-- NOTE: All users have password = "secret" (hashed below)
INSERT INTO users (email, username, full_name, hashed_password, is_active, is_superuser, created_at, updated_at) VALUES
-- Admin/HR Users (password: "secret")
('hr.manager@company.com', 'hr_manager', 'Sarah Johnson', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, true, NOW() - INTERVAL '90 days', NOW() - INTERVAL '90 days'),
('admin.lead@company.com', 'admin_lead', 'Michael Chen', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, true, NOW() - INTERVAL '85 days', NOW() - INTERVAL '85 days'),

-- Regular Employees (password: "secret")
('john.doe@company.com', 'john_doe', 'John Doe', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, false, NOW() - INTERVAL '80 days', NOW() - INTERVAL '80 days'),
('jane.smith@company.com', 'jane_smith', 'Jane Smith', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, false, NOW() - INTERVAL '75 days', NOW() - INTERVAL '75 days'),
('alex.wilson@company.com', 'alex_wilson', 'Alex Wilson', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, false, NOW() - INTERVAL '70 days', NOW() - INTERVAL '70 days'),
('emma.brown@company.com', 'emma_brown', 'Emma Brown', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, false, NOW() - INTERVAL '65 days', NOW() - INTERVAL '65 days'),
('david.taylor@company.com', 'david_taylor', 'David Taylor', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, false, NOW() - INTERVAL '60 days', NOW() - INTERVAL '60 days'),
('lisa.garcia@company.com', 'lisa_garcia', 'Lisa Garcia', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, false, NOW() - INTERVAL '55 days', NOW() - INTERVAL '55 days'),
('ryan.martinez@company.com', 'ryan_martinez', 'Ryan Martinez', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, false, NOW() - INTERVAL '50 days', NOW() - INTERVAL '50 days'),
('sophia.lee@company.com', 'sophia_lee', 'Sophia Lee', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, false, NOW() - INTERVAL '45 days', NOW() - INTERVAL '45 days'),
('james.anderson@company.com', 'james_anderson', 'James Anderson', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, false, NOW() - INTERVAL '40 days', NOW() - INTERVAL '40 days'),
('olivia.thomas@company.com', 'olivia_thomas', 'Olivia Thomas', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', true, false, NOW() - INTERVAL '35 days', NOW() - INTERVAL '35 days');

-- Insert Vibe Logs (Past 60 days with realistic patterns)
-- This creates a realistic distribution of moods, energy levels, and satisfaction scores

-- Helper function to generate random vibe logs
DO $$
DECLARE
    user_record RECORD;
    day_offset INTEGER;
    hour_offset INTEGER;
    mood_val TEXT;
    energy_val INTEGER;
    complexity_val TEXT;
    satisfaction_val INTEGER;
    sentiment_val INTEGER;
    moods TEXT[] := ARRAY['sad', 'angry', 'happy', 'good', 'excited'];
    complexities TEXT[] := ARRAY['easy', 'medium', 'hard', 'very_hard'];
    log_date TIMESTAMP;
    weekend_factor FLOAT;
    monday_factor FLOAT;
BEGIN
    -- Loop through each non-superuser
    FOR user_record IN 
        SELECT id FROM users WHERE is_superuser = false
    LOOP
        -- Generate logs for past 60 days
        FOR day_offset IN 0..59 LOOP
            log_date := NOW() - INTERVAL '1 day' * day_offset;
            
            -- Skip some days randomly (not everyone logs every day)
            IF random() < 0.15 THEN
                CONTINUE;
            END IF;
            
            -- Weekend factor (lower energy/satisfaction on weekends sometimes)
            weekend_factor := CASE 
                WHEN EXTRACT(DOW FROM log_date) IN (0, 6) THEN 0.8 
                ELSE 1.0 
            END;
            
            -- Monday factor (Monday blues)
            monday_factor := CASE 
                WHEN EXTRACT(DOW FROM log_date) = 1 THEN 0.7 
                ELSE 1.0 
            END;
            
            -- Generate 1-3 logs per day
            FOR hour_offset IN 1..(1 + floor(random() * 3)::INTEGER) LOOP
                -- Realistic mood distribution
                mood_val := CASE 
                    WHEN random() < 0.05 THEN 'SAD'
                    WHEN random() < 0.15 THEN 'ANGRY'
                    WHEN random() < 0.45 THEN 'GOOD'
                    WHEN random() < 0.75 THEN 'HAPPY'
                    ELSE 'EXCITED'
                END;
                
                -- Energy level (1-5, affected by weekend/monday factors)
                energy_val := GREATEST(1, LEAST(5, 
                    floor(3 + random() * 2 * weekend_factor * monday_factor)::INTEGER
                ));
                
                -- Complexity distribution
                complexity_val := CASE 
                    WHEN random() < 0.3 THEN 'EASY'
                    WHEN random() < 0.6 THEN 'MEDIUM'
                    WHEN random() < 0.85 THEN 'HARD'
                    ELSE 'VERY_HARD'
                END;
                
                -- Satisfaction (0-10, correlated with mood and energy)
                satisfaction_val := CASE mood_val
                    WHEN 'sad' THEN floor(random() * 4)::INTEGER
                    WHEN 'angry' THEN floor(random() * 3)::INTEGER
                    WHEN 'good' THEN floor(5 + random() * 4)::INTEGER
                    WHEN 'happy' THEN floor(6 + random() * 4)::INTEGER
                    WHEN 'excited' THEN floor(7 + random() * 4)::INTEGER
                END;
                satisfaction_val := GREATEST(0, LEAST(10, satisfaction_val));
                
                -- Sentiment rating (AI-like correlation)
                sentiment_val := GREATEST(0, LEAST(100, 
                    floor(satisfaction_val * 8 + energy_val * 5 + random() * 20)::INTEGER
                ));
                
                INSERT INTO vibelogs (
                    user_id, summary, mood, energy_level, complexity, satisfaction, 
                    sentiment_rating, created_at, updated_at
                ) VALUES (
                    user_record.id,
                    'Daily vibe check',
                    mood_val::moodenum,
                    energy_val,
                    complexity_val::complexityenum,
                    satisfaction_val,
                    sentiment_val,
                    log_date + INTERVAL '1 hour' * (8 + hour_offset + random() * 8),
                    log_date + INTERVAL '1 hour' * (8 + hour_offset + random() * 8)
                );
            END LOOP;
        END LOOP;
    END LOOP;
END $$;

-- Insert Vibe Reports (AI-generated reports by admins)
INSERT INTO vibereports (user_id, generated_by, report_data, period_start, period_end, created_at, updated_at)
SELECT 
    u.id as user_id,
    (SELECT id FROM users WHERE is_superuser = true LIMIT 1) as generated_by,
    jsonb_build_object(
        'summary', 'Employee showing ' || 
            CASE 
                WHEN random() < 0.3 THEN 'excellent performance with high energy levels'
                WHEN random() < 0.6 THEN 'good overall wellbeing with some stress indicators'
                ELSE 'moderate satisfaction with room for improvement'
            END,
        'mood_analysis', jsonb_build_object(
            'dominant_mood', (ARRAY['happy', 'good', 'excited'])[floor(random() * 3 + 1)],
            'mood_stability', round((random() * 40 + 60)::NUMERIC, 1),
            'trend', (ARRAY['improving', 'stable', 'declining'])[floor(random() * 3 + 1)]
        ),
        'energy_analysis', jsonb_build_object(
            'average_energy', round((random() * 2 + 3)::NUMERIC, 1),
            'consistency', round((random() * 30 + 70)::NUMERIC, 1),
            'peak_days', ARRAY['Tuesday', 'Wednesday', 'Thursday']
        ),
        'satisfaction_analysis', jsonb_build_object(
            'average_satisfaction', round((random() * 3 + 6)::NUMERIC, 1),
            'satisfaction_drivers', ARRAY['task_complexity', 'team_collaboration', 'work_environment'],
            'improvement_areas', ARRAY['work_life_balance', 'task_variety']
        ),
        'recommendations', ARRAY[
            'Consider flexible working hours during peak energy times',
            'Provide more challenging tasks to maintain engagement',
            'Schedule regular check-ins for stress management'
        ],
        'risk_factors', ARRAY[
            CASE WHEN random() < 0.5 THEN 'workload_intensity' ELSE 'task_monotony' END,
            CASE WHEN random() < 0.5 THEN 'communication_gaps' ELSE 'unclear_expectations' END
        ]
    ) as report_data,
    NOW() - INTERVAL '30 days' as period_start,
    NOW() as period_end,
    NOW() - INTERVAL '2 days' + INTERVAL '1 hour' * (random() * 48) as created_at,
    NOW() - INTERVAL '2 days' + INTERVAL '1 hour' * (random() * 48) as updated_at
FROM users u 
WHERE u.is_superuser = false;

-- Insert Burnout Scores (Admin/HR only data)
INSERT INTO burnoutscores (user_id, burnout_score, period_start, period_end, created_at, updated_at)
SELECT 
    u.id as user_id,
    -- Realistic burnout scores (0-100, most people in 20-60 range)
    CASE 
        WHEN random() < 0.1 THEN floor(random() * 20)::INTEGER  -- Low burnout (10%)
        WHEN random() < 0.7 THEN floor(20 + random() * 40)::INTEGER  -- Medium burnout (60%)
        WHEN random() < 0.95 THEN floor(60 + random() * 30)::INTEGER  -- High burnout (25%)
        ELSE floor(90 + random() * 10)::INTEGER  -- Critical burnout (5%)
    END as burnout_score,
    NOW() - INTERVAL '30 days' as period_start,
    NOW() as period_end,
    NOW() - INTERVAL '1 day' + INTERVAL '1 hour' * (random() * 24) as created_at,
    NOW() - INTERVAL '1 day' + INTERVAL '1 hour' * (random() * 24) as updated_at
FROM users u 
WHERE u.is_superuser = false;

-- Insert additional burnout scores for trend analysis (weekly scores for past 8 weeks)
DO $$
DECLARE
    user_record RECORD;
    week_offset INTEGER;
    base_score INTEGER;
    score_variation INTEGER;
BEGIN
    FOR user_record IN 
        SELECT id FROM users WHERE is_superuser = false
    LOOP
        -- Get a base burnout score for this user
        base_score := 20 + floor(random() * 50)::INTEGER;
        
        FOR week_offset IN 1..8 LOOP
            -- Add some variation each week (-10 to +10)
            score_variation := floor(random() * 21 - 10)::INTEGER;
            
            INSERT INTO burnoutscores (user_id, burnout_score, period_start, period_end, created_at, updated_at)
            VALUES (
                user_record.id,
                GREATEST(0, LEAST(100, base_score + score_variation)),
                NOW() - INTERVAL '1 week' * week_offset - INTERVAL '7 days',
                NOW() - INTERVAL '1 week' * week_offset,
                NOW() - INTERVAL '1 week' * week_offset + INTERVAL '1 day',
                NOW() - INTERVAL '1 week' * week_offset + INTERVAL '1 day'
            );
            
            -- Gradually adjust base score for trend
            base_score := GREATEST(0, LEAST(100, base_score + floor(random() * 11 - 5)::INTEGER));
        END LOOP;
    END LOOP;
END $$;

-- Summary of inserted data
SELECT 
    'Users' as table_name, 
    COUNT(*) as record_count 
FROM users
UNION ALL
SELECT 
    'Vibe Logs' as table_name, 
    COUNT(*) as record_count 
FROM vibelogs
UNION ALL
SELECT 
    'Vibe Reports' as table_name, 
    COUNT(*) as record_count 
FROM vibereports
UNION ALL
SELECT 
    'Burnout Scores' as table_name, 
    COUNT(*) as record_count 
FROM burnoutscores
ORDER BY table_name;

-- Sample queries to verify data
SELECT 'Recent Vibe Logs Sample' as info;
SELECT 
    u.full_name,
    vl.mood,
    vl.energy_level,
    vl.satisfaction,
    vl.created_at
FROM vibelogs vl
JOIN users u ON vl.user_id = u.id
ORDER BY vl.created_at DESC
LIMIT 10;

SELECT 'Mood Distribution' as info;
SELECT 
    mood,
    COUNT(*) as count,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ())::numeric, 1) as percentage
FROM vibelogs
GROUP BY mood
ORDER BY count DESC;

SELECT 'Average Satisfaction by User' as info;
SELECT 
    u.full_name,
    ROUND(AVG(vl.satisfaction)::numeric, 1) as avg_satisfaction,
    COUNT(vl.id) as total_logs
FROM users u
LEFT JOIN vibelogs vl ON u.id = vl.user_id
WHERE u.is_superuser = false
GROUP BY u.id, u.full_name
ORDER BY avg_satisfaction DESC;
