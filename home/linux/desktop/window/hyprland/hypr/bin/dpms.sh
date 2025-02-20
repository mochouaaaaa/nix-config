#!/usr/bin/env bash


if pgrep swaylock > /dev/null; the
    hyprctl dispatch dpms off
fi
