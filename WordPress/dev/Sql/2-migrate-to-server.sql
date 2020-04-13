-- /* This file is used to change Website address when moving from one environment to another */
UPDATE DuD_options SET option_value = replace(option_value, 'http://localhost:8080', 'https://siteurl.com') WHERE option_name = 'home' OR option_name = 'siteurl';
UPDATE DuD_posts SET guid = replace(guid, 'http://localhost:8080','https://siteurl.com');
UPDATE DuD_posts SET post_content = replace(post_content, 'http://localhost:8080', 'https://siteurl.com');
-- UPDATE C5N_postmeta SET meta_value = replace(meta_value,'default','http://localhost:8080');
