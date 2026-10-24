# Assignment requirement audit

Reviewed directly against all three pages of HW1.pdf on 24 October 2026.
After the visual refresh, Flutter 3.47.6 static analysis and all five tests passed;
the four updated screenshots were visually inspected.


Implementation is complete for the app features. Submission items remain open
where the team or an external account must supply information.
**45 of 47 checklist items are complete; the two remaining items concern team details and external submission.** See README for
actual SDK and validation evidence. [x] means implemented or supplied; [ ] means pending.

## Event data and Explore — 15 points

- [x] 1. Six fictional events across three categories (`lib/data/events.dart`).
- [x] 2. Unique ID, title, category, date/time, venue, description, local image, capacity, initial availability.
- [x] 3. Initially full event and exactly one-place event.
- [x] 4. Dates after 25 October 2026; capacity bounds and duplicate operations tested.
- [x] 5. Scrollable cards include all required summary fields, favorite control and details access.
- [x] 6. Three distinct bundled local PNG images.

## Search and category filters — 15 points

- [x] 7. Case-insensitive title search with surrounding spaces trimmed.
- [x] 8. All, Technology, Arts and Sports categories.
- [x] 9. Query and category combine.
- [x] 10. Matching count reflects selected tab and filters.
- [x] 11. Readable no-results message and clear-search/filter controls.
- [x] 12. Query and category survive switching all three tabs.

## Details and image viewer — 15 points

- [x] 13. Separate details route from every card.
- [x] 14. All event fields, including initial and current availability and total capacity.
- [x] 15. Double-tap image opens separate enlarged viewer.
- [x] 16. Normal Back from both routes.
- [x] 17. Favorite and participation controls in details.
- [x] 18. Changes reflected on return through shared controller and setState.

## Favorites and My Events — 15 points

- [x] 19. Explore, Favorites and My Events navigation.
- [x] 20. Favorites includes only favorited events.
- [x] 21. My Events includes only joined events.
- [x] 22. Useful empty states for both collections.
- [x] 23. Favorite/unfavorite on cards and details.
- [x] 24. Shared favorite state across views and details.
- [x] 25. Favorite changes do not affect participation/capacity.

## Join and cancel — 20 points

- [x] 26. Join confirmation includes title, date/time, venue, Yes and No.
- [x] 27. No or outside dismissal changes nothing.
- [x] 28. Yes joins once, deducts one place and shows feedback.
- [x] 29. Joined events offer Cancel participation with confirmation.
- [x] 30. Cancellation removes participation, restores a place and updates My Events.
- [x] 31. Duplicate joins and repeated capacity deductions prevented.
- [x] 32. Full unjoined event has disabled joining and Full label.
- [x] 33. Last-place participant can still cancel.
- [x] 34. Total joined count displayed independently of filters.

## Layout, assets and font — 10 points

- [x] 35. MaterialApp, Scaffold, Row, Column, Padding, Expanded and scrollable layout.
- [x] 36. Reusable StatelessWidget EventCard and StatefulWidget screens.
- [x] 37. Simple setState updates with plain Dart controller.
- [x] 38. Images declared in pubspec.yaml.
- [x] 39. Outfit font bundled, declared and visibly applied.
- [x] 40. Image/font credits and licenses included.

## Source, README and evidence — 10 points

- [x] 41. Flutter 3.47.6 Stable verified; analysis and all five tests pass; actual output in README.
- [x] 42. Flutter source, lib/, pubspec, lockfile, assets and platform configuration supplied.
- [x] 43. Generated build/ and .dart_tool/ excluded by archive script and .gitignore.
- [ ] 44. README has setup/run, credits and limitations; second member and actual individual contributions still needed.
- [x] 45. Four real Flutter-rendered preview screenshots supplied.
- [x] 46. Short test checklist and automated full/cancel-dialog/empty-search checks supplied.
- [ ] 47. Team must upload an accessible repository/archive and submit its link through ESTUOYS by deadline.

Publication and ESTUOYS submission require the team's chosen destination/account.
The clean source archive can be regenerated with `python3 tools/package_source.py`.
