workspace "BP Strat Website Source" "Source and publication pipeline for the BP Strat public website." {
  model {
    editor = person "Content Editor" "Maintains BP Strat pages, articles, diagrams, and navigation in Markdown and Obsidian."
    visitor = person "Website Visitor" "Reads BP Strat content on the public website."

    website = softwareSystem "BP Strat Website Source" "Builds the BP Strat public website from versioned Markdown and Jekyll templates." {
      properties {
        "bpstack.orgKey" "bpstrat"
        "bpstack.productKey" "jekyllrb-websites"
        "bpstack.projectKey" "bpstrat-website-source"
        "bpstack.projectType" "static_website"
        "bpstack.owner" "gpupo"
        "bpstack.criticality" "medium"
        "bpstack.defaultView" "container"
        "repo" "ssh://git@git.homelab.gpupo.com/gpupo/website-source.git"
        "runbook" "README.md"
      }

      content = container "Content Vault" "Holds the website pages, posts, diagrams, navigation metadata, and assets as versioned source." "Markdown + Obsidian"
      generator = container "Static Site Generator" "Transforms the source into the public site with search, feeds, SEO metadata, Mermaid, and the BP Strat visual theme." "Ruby 3.2 + Jekyll 4.3 + Just the Docs"
      staticSite = container "Generated Static Website" "Immutable HTML, CSS, JavaScript, feeds, images, and metadata served to visitors." "Static Web Assets"
    }

    compiledRepository = softwareSystem "BP Strat Compiled Repository" "Receives generated site files for the bp-strat/bpstrat.com.br publication repository; it is a deploy artifact, not an editable source." {
      tags "External"
      properties {
        "repo" "git@github.com:bp-strat/bpstrat.com.br.git"
      }
    }

    githubPages = softwareSystem "GitHub Pages" "Hosts the public BP Strat website at www.bpstrat.com.br." {
      tags "External"
    }

    editor -> content "Edits and reviews source content" "Obsidian / Git"
    content -> generator "Provides pages, templates, configuration, and assets" "Filesystem"
    generator -> staticSite "Builds the production website" "Jekyll build"
    generator -> compiledRepository "Copies generated output for repository-based publication" "Filesystem / Git"
    staticSite -> githubPages "Is published as the site artifact" "GitHub Pages deployment"
    visitor -> githubPages "Reads www.bpstrat.com.br" "HTTPS"

    deploymentEnvironment "Production" {
      github = deploymentNode "GitHub" "Runs the Pages publication workflow and hosts the public site." "GitHub Actions + GitHub Pages" {
        pages = deploymentNode "BP Strat Pages" "Serves the BP Strat custom domain." "GitHub Pages" {
          staticSiteInstance = containerInstance staticSite
        }
      }
    }
  }

  views {
    systemContext website "context" {
      include *
      autolayout lr
    }
    container website "container" {
      include *
      autolayout lr
    }
    deployment website "Production" "deployment-production" {
      include *
      autolayout lr
    }
    styles {
      element "External" {
        border dashed
        opacity 70
      }
    }
  }
}
