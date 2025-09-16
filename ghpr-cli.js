#!/usr/bin/env node

const { execSync } = require('child_process');
const prompts = require('prompts');

// Colors for console output
const colors = {
    reset: '\x1b[0m',
    bright: '\x1b[1m',
    red: '\x1b[31m',
    green: '\x1b[32m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
    magenta: '\x1b[35m',
    cyan: '\x1b[36m'
};

function log(message, color = 'reset') {
    console.log(`${colors[color]}${message}${colors.reset}`);
}

function execCommand(command, options = {}) {
    try {
        const result = execSync(command, {
            encoding: 'utf8',
            stdio: options.silent ? 'pipe' : 'inherit',
            ...options
        });
        return result || '';
    } catch (error) {
        if (!options.silent) {
            log(`Error executing command: ${command}`, 'red');
            log(error.message, 'red');
        }
        throw error;
    }
}

async function getGitHubCollaborators() {
    try {
        log('Fetching GitHub collaborators...', 'blue');
        const output = execCommand('gh api repos/secoda/secoda/collaborators | jq -r \'.[].login\'', { silent: true });
        return output.trim().split('\n').filter(username => username.length > 0);
    } catch (error) {
        log('Failed to fetch collaborators. Make sure you have GitHub CLI installed and are authenticated.', 'red');
        log('You can install GitHub CLI with: brew install gh', 'yellow');
        log('And authenticate with: gh auth login', 'yellow');
        return [];
    }
}

async function getCurrentBranch() {
    try {
        return execCommand('git rev-parse --abbrev-ref HEAD', { silent: true }).trim();
    } catch (error) {
        log('Not in a git repository', 'red');
        process.exit(1);
    }
}

async function checkExistingPR(branch) {
    try {
        const output = execCommand(`gh pr list --base main --head "${branch}" --json url,number,title`, { silent: true });
        const prs = JSON.parse(output);
        return prs.length > 0 ? prs[0] : null;
    } catch (error) {
        return null;
    }
}

async function getPRUrl(branch) {
    try {
        const prQuery = `gh pr list --head "${branch}" --json url --jq '.[0].url'`;
        const prUrlOutput = execCommand(prQuery, { silent: true });
        const prUrl = prUrlOutput.trim();
        return prUrl && prUrl !== 'null' ? prUrl : null;
    } catch (error) {
        return null;
    }
}

async function createOrUpdatePR(title, reviewers, assignees, existingPR, currentBranch) {
    try {
        // Push the current branch
        log('Pushing current branch...', 'blue');
        execCommand('git push');

        let prUrl;

        if (existingPR) {
            log(`Updating existing PR #${existingPR.number}...`, 'blue');

            // Update the PR title
            execCommand(`gh pr edit ${existingPR.number} --title "${title}"`, { silent: true });

            // Add reviewers if any
            if (reviewers.length > 0) {
                execCommand(`gh pr edit ${existingPR.number} --add-reviewer ${reviewers.join(',')}`, { silent: true });
            }

            // Add assignees if any
            if (assignees.length > 0) {
                execCommand(`gh pr edit ${existingPR.number} --add-assignee ${assignees.join(',')}`, { silent: true });
            }

            // Get the PR URL
            prUrl = await getPRUrl(currentBranch);
            if (prUrl) {
                log(`PR updated: ${prUrl}`, 'green');
            } else {
                log('Could not retrieve PR URL', 'yellow');
            }
        } else {
            log('Creating new PR...', 'blue');

            // Build the gh pr create command
            let createCommand = `gh pr create --fill --title "${title}"`;

            if (reviewers.length > 0) {
                createCommand += ` --reviewer ${reviewers.join(',')}`;
            }

            if (assignees.length > 0) {
                createCommand += ` --assignee ${assignees.join(',')}`;
            }

            // Create the PR (don't capture output as it might be empty)
            execCommand(createCommand);

            // Get the PR URL
            prUrl = await getPRUrl(currentBranch);
            if (prUrl) {
                log(`PR created: ${prUrl}`, 'green');
            } else {
                log('PR created but could not retrieve URL', 'yellow');
            }
        }

        return prUrl;
    } catch (error) {
        log('Failed to create/update PR', 'red');
        log(error.message, 'red');
        return null;
    }
}

async function main() {
    log('🚀 GitHub PR Assistant', 'bright');
    log('====================', 'bright');

    // Get current branch
    const currentBranch = await getCurrentBranch();
    log(`Current branch: ${currentBranch}`, 'cyan');

    // Check for existing PR
    const existingPR = await checkExistingPR(currentBranch);
    if (existingPR) {
        log(`Found existing PR: #${existingPR.number} - ${existingPR.title}`, 'yellow');
    }

    // Get GitHub collaborators
    const collaborators = await getGitHubCollaborators();

    if (collaborators.length === 0) {
        log('No collaborators found. Proceeding without reviewer/assignee selection.', 'yellow');
    }

    // Interactive prompts
    const questions = [
        {
            type: 'text',
            name: 'prefix',
            message: 'Enter a prefix for the PR title (e.g., fix, feat, docs):',
            initial: existingPR ? existingPR.title.split(':')[0] : 'fix',
            validate: value => value.trim().length > 0 ? true : 'Prefix is required'
        }
    ];

    // Add collaborator selection if we have collaborators
    if (collaborators.length > 0) {
        questions.push(
            {
                type: 'multiselect',
                name: 'reviewers',
                message: 'Select reviewers (use space to select, enter to confirm):',
                choices: collaborators.map(username => ({
                    title: username,
                    value: username,
                    selected: false
                })),
                instructions: false
            },
            // {
            //     type: 'multiselect',
            //     name: 'assignees',
            //     message: 'Select assignees (use space to select, enter to confirm):',
            //     choices: collaborators.map(username => ({
            //         title: username,
            //         value: username,
            //         selected: false
            //     })),
            //     instructions: false
            // }
        );
    }

    const response = await prompts(questions);

    if (!response.prefix) {
        log('Operation cancelled', 'yellow');
        process.exit(0);
    }

    // Generate PR title
    const title = `${response.prefix}: ${currentBranch}`;
    log(`\nGenerated PR title: ${title}`, 'cyan');

    // Create or update PR
    const reviewers = response.reviewers || [];
    const assignees = response.assignees || [];

    if (reviewers.length > 0) {
        log(`Reviewers: ${reviewers.join(', ')}`, 'blue');
    }

    if (assignees.length > 0) {
        log(`Assignees: ${assignees.join(', ')}`, 'blue');
    }

    const prUrl = await createOrUpdatePR(title, reviewers, assignees, existingPR, currentBranch);

    if (prUrl) {
        log('\n📋 Copy and paste the following in Slack:', 'bright');
        log(`[${title}](${prUrl})`, 'green');
    } else {
        log('Failed to create/update PR', 'red');
        process.exit(1);
    }
}

// Handle Ctrl+C gracefully
process.on('SIGINT', () => {
    log('\n\nOperation cancelled by user', 'yellow');
    process.exit(0);
});

// Run the main function
main().catch(error => {
    log(`\nUnexpected error: ${error.message}`, 'red');
    process.exit(1);
});
