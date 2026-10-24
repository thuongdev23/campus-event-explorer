"""Create a clean submission zip without generated files or machine settings."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

root = Path(__file__).resolve().parent.parent
out = root / 'dist' / 'campus-event-explorer-source.zip'
out.parent.mkdir(exist_ok=True)
excluded = {'.git', '.dart_tool', 'build', 'dist', '.idea', '.DS_Store',
            '.gradle', 'Pods', '.symlinks', 'ephemeral', 'coverage', 'failures', '__pycache__'}
local_files = {'local.properties', 'Generated.xcconfig', 'flutter_export_environment.sh',
               '.flutter-plugins-dependencies', 'GeneratedPluginRegistrant.java'}
with ZipFile(out, 'w', ZIP_DEFLATED) as archive:
    for path in sorted(root.rglob('*')):
        relative = path.relative_to(root)
        if (not path.is_file() or any(part in excluded for part in relative.parts)
                or path.name in local_files or path.suffix in {'.iml', '.pyc'}):
            continue
        archive.write(path, Path('campus_event_explorer') / relative)
print(out)
