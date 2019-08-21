#!/usr/bin/env python3
import configparser
import sys

config = configparser.ConfigParser()
config.read('/ops/utils/env_vars.ini')


def get_config(env: str, setting: str) -> str:
    """ Read value from config file """
    return config.get(env, setting)


if __name__ == "__main__":
    """ 
    Helper function to parse the env_vars.ini file that's mapped in the docker compose.  Usage:
    python parse_config.py foss4g_ops github_oauth 
    """
    try:
        env = sys.argv[1]
        setting = sys.argv[2]
    except IndexError:
        sys.stderr.write("Env or setting not supplied")
        sys.exit(1)

    setting_value = get_config(env, setting)
    print(setting_value)
