# Production Deployment Configuration

#### All configurations in this directory AND on master branch DIRECTLY alter Clincard Production. We do not directly update master, any changes to files within this directory must go through proper GITHUB branching steps below:

 * Create a local branch off of master
 * Make deployment changes required in both the ccsqa/staging directory and the same changes need to be implemented in ccprod01/prod
 * Commit and push branch to origin
 * Create a PR against staging branch, this PR will requires approval before it can get merged into staging.
 * Once merged into staging branch it will be deployed to staging environment for testing.
 * Once stage testing is successfully completed a DEV LEAD will create a PR to merge staging into master
 * All Leads review this PR to verify before approving.
 * During deployment window merge the above PR into master which will push changes to Production EKS cluster.
 
