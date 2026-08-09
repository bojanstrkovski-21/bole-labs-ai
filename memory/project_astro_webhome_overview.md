---
name: project-astro-webhome-overview
description: "What astro-webhome is and its current structure (Astro bookmark dashboard, Everforest theme, two themes, font toggle)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 539b9399-9f39-4eac-994d-bf7cab3e12ad
---

astro-webhome ([/home/bojanstrko/DATA/astro-webhome](/home/bojanstrko/DATA/astro-webhome)) is Bojan's personal bookmark/dashboard homepage built with Astro 7 (static output, deployed via Cloudflare Pages per wrangler.toml). Pages: index (home, email/info/cloud/webapps link groups + search bar), e-servisi (government e-service buttons), institucii (ministries/institutions/banks, tabbed), linux (distro/news/forum/github links, tabbed).

Styling lives almost entirely in [src/layouts/Layout.astro](src/layouts/Layout.astro) as one large `<style is:global>` block — pages just provide markup/data.

Two themes toggled via `data-theme` attribute, saved to localStorage key `theme`:
- `solid` — flat Everforest medium-dark colors (sun icon)
- `transparent` — self-hosted wallpaper.jpg background with translucent/blurred cards (moon icon)

Color system: raw Everforest vars (`--bg-dim`, `--bg0`..`--bg5`, `--fg`, `--green`, etc.) defined once in `:root`, then semantic vars (`--primary-bg`, `--card-bg`, `--accent-bg`, etc.) redefined per `[data-theme]`.

Font toggle (separate from color theme) via `data-font` attribute, localStorage key `font`: `inter` (self-hosted via @fontsource/inter) or `meslo` (MesloLGS Nerd Font, self-hosted ttf in public/fonts/meslo/, copied from user's system fonts). Toggle buttons "in"/"me" sit next to the theme toggle in the nav.

See [[project-astro-webhome-keycap-buttons]] for the button redesign and [[reference-astro-webhome-visual-testing]] for how changes were verified.
