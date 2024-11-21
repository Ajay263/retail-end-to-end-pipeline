name: Data Pipeline Infrastructure Deployment
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
# Permissions for the GitHub Actions workflow
permissions:
  contents: read
  pull-requests: write
env:
  TF_VERSION: 1.5.7
  AWS_REGION: eu-north-1
  TF_WORKING_DIRECTORY: ./terraform
jobs:
  terraform-plan:
    name: 'Terraform Plan'
    runs-on: ubuntu-latest
    
    steps:
    # Checkout the repository
    - name: Checkout Code
      uses: actions/checkout@v3
    
    # Setup AWS Credentials
    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ env.AWS_REGION }}
    
    # Setup Terraform
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: ${{ env.TF_VERSION }}
        terraform_wrapper: false
    
    # Initialize Terraform
    - name: Terraform Init
      run: |
        cd ${{ env.TF_WORKING_DIRECTORY }}
        terraform init \
          -backend-config="bucket=${{ secrets.TF_STATE_BUCKET }}" \
          -backend-config="key=data-pipeline/terraform.tfstate" \
          -backend-config="region=${{ env.AWS_REGION }}" \
          -lock=false
    
    # Validate Terraform configuration
    - name: Terraform Validate
      run: |
        cd ${{ env.TF_WORKING_DIRECTORY }}
        terraform validate
    
    # Generate Terraform Plan
    - name: Terraform Plan
      id: plan
      run: |
        cd ${{ env.TF_WORKING_DIRECTORY }}
        terraform plan -no-color -out=tfplan
      continue-on-error: true
    
    # Add Plan as PR Comment
    - name: Terraform Plan Comment
      uses: actions/github-script@v6
      if: github.event_name == 'pull_request'
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}
        script: |
          const output = `#### Terraform Plan 📋
          \`\`\`
          ${{ steps.plan.outputs.stdout }}
          \`\`\`
          `;
          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: output
          })
  
  terraform-apply:
    name: 'Terraform Apply'
    needs: terraform-plan
    runs-on: ubuntu-latest
    # Only run apply on main branch
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    steps:
    # Checkout the repository
    - name: Checkout Code
      uses: actions/checkout@v3
    
    # Setup AWS Credentials
    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ env.AWS_REGION }}
    
    # Setup Terraform
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: ${{ env.TF_VERSION }}
        terraform_wrapper: false
    
    # Initialize Terraform
    - name: Terraform Init
      run: |
        cd ${{ env.TF_WORKING_DIRECTORY }}
        terraform init \
          -backend-config="bucket=${{ secrets.TF_STATE_BUCKET }}" \
          -backend-config="key=data-pipeline/terraform.tfstate" \
          -backend-config="region=${{ env.AWS_REGION }}" \
          -lock=false
    
    # Apply Terraform Changes
    - name: Terraform Apply
      run: |
        cd ${{ env.TF_WORKING_DIRECTORY }}
        terraform apply -auto-approve tfplan
