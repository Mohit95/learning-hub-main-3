-- ============================================================================
-- 00009_lesson_resource_urls.sql
-- Sets video_url for specific Phase 1 lessons so Watch / Read links work.
-- video_url is used as a generic resource URL for both videos and readings.
-- ============================================================================

-- "What is Product Management?" video → YouTube link
UPDATE lessons
SET video_url = 'https://www.youtube.com/watch?v=5nAeyqNuZYU'
WHERE title = 'What is Product Management?' AND lesson_type = 'video';

-- "Good Product Manager / Bad Product Manager" reading → a16z essay
UPDATE lessons
SET video_url = 'https://a16z.com/good-product-manager-bad-product-manager/'
WHERE title = 'Good Product Manager / Bad Product Manager' AND lesson_type = 'reading';

-- "What is Product Management?" reading → Lenny's Newsletter
UPDATE lessons
SET video_url = 'https://www.lennysnewsletter.com/p/what-is-product-management'
WHERE title = 'What is Product Management?' AND lesson_type = 'reading';
