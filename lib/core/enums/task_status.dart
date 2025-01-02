enum TaskStatus {
  pending('Pending'),
  inProgress('In Progress'),
  completed('Completed');

  final String value;
  const TaskStatus(this.value);
}
