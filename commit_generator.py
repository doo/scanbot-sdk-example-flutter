import git
import re

# Step 1: Fetch Git Diff Data
def get_git_diff():
    repo = git.Repo(".")
    diffs = repo.git.diff("HEAD")  # Compare with the last commit
    return diffs

# Step 2: Parse the Diff Output
def parse_diff(diffs):
    changes = {"added": [], "removed": [], "modified": []}
    for line in diffs.splitlines():
        if line.startswith("+") and not line.startswith("+++"):
            changes["added"].append(line[1:])
        elif line.startswith("-") and not line.startswith("---"):
            changes["removed"].append(line[1:])
    return changes

# Step 3: Generate a Commit Message
def generate_commit_message(changes):
    message_parts = []
    if changes["added"]:
        message_parts.append(f"Added {len(changes['added'])} lines.")
    if changes["removed"]:
        message_parts.append(f"Removed {len(changes['removed'])} lines.")
    if changes["modified"]:
        message_parts.append(f"Modified {len(changes['modified'])} files.")
    
    return " ".join(message_parts)

# Step 4: Automate the Commit
def create_commit(message):
    repo = git.Repo(".")
    repo.git.add(A=True)  # Stage all changes
    repo.index.commit(message)
    print("Commit created:", message)

# Step 5: Putting It All Together
if __name__ == "__main__":
    diffs = get_git_diff()
    changes = parse_diff(diffs)
    commit_message = generate_commit_message(changes)
    create_commit(commit_message)
