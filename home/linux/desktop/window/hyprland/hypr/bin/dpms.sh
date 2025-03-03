#!/usr/bin/env bash


if pgrep swaylock > /dev/null; then
    hyprctl dispatch dpms off
fi
