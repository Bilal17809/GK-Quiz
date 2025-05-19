enum ResourceStatus { initial, loading, success, failure }

class Resource<T> {
  final ResourceStatus status;
  final T? data;
  final String? errorMessage;

  const Resource._({
    required this.status,
    this.data,
    this.errorMessage,
  });

  const Resource.initial() : this._(status: ResourceStatus.initial);
  const Resource.loading({T? data})
      : this._(status: ResourceStatus.loading, data: data);
  const Resource.success(T data)
      : this._(status: ResourceStatus.success, data: data);
  const Resource.failure(String errorMessage)
      : this._(status: ResourceStatus.failure, errorMessage: errorMessage);
}
