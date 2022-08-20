"""Script to bundle the addon for deployment in a WoW Interface Addon folder."""
import os
import shutil


def main():
    addon_name = os.path.basename(os.path.abspath('.'))
    src_dir = "src"
    target_dir = "target"
    target_src = os.path.join(target_dir, addon_name)
    zip_file = os.path.join(target_dir, addon_name)

    # remove all prior build artifacts
    shutil.rmtree(target_dir, ignore_errors=True)
    # copy addon files from src to target folder
    shutil.copytree(src_dir, target_src)
    # zip the addon files
    shutil.make_archive(zip_file, 'zip', target_dir, addon_name)

    # dev deploy into addon folder
    shutil.copytree(src_dir, '.', dirs_exist_ok=True)


if __name__ == '__main__':
    main()
