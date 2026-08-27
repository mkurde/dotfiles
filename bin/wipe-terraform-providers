#!/usr/bin/env nu

# Wipe downloaded Terraform providers from your system.
def main [
    dir: string # Base directory used for scanning.
    --threshold: filesize = 10MiB # Size threshold to remove directories.
] {
    cd $dir

    let excludes: list<glob> = [
        **/pkg/mod/**
    ]
    print -e "Compiling list of provider directories to remove. This might take a while..."
    let dirs = (
        glob --no-file --exclude $excludes **/.terraform/providers
        | each { |dir|
            let size: filesize = du $dir | get physical.0
            if $size > $threshold {
                return {
                    path: $dir,
                    size: $size
                }
            }
        }
    )

    if ($dirs | is-empty) {
        print -e "Nothing to remove."
        return
    }

    print -e "The following directories will be removed:"
    print $dirs

    let decision = (
        input --default "n" --numchar 1 "Do you want to proceed? [y/N]: "
    ) | str downcase

    if $decision == "n" {
        print -e "Aborting..."
        return
    }

    let sizes: list<filesize> = $dirs | each { |dir|
        let path: string = $dir.path
        let size: filesize = $dir.size
        print -e $"Removing: ($path) (($size))"
        rm -rf $path
        return $size
    }
    let freed = $sizes | math sum
    print -e $"Freed up: ($freed)"
}
