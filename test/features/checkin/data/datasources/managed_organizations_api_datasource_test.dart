import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/checkin/data/datasources/managed_organizations_api_datasource.dart';
import 'package:lehiboo/features/checkin/domain/entities/active_organization.dart';

void main() {
  test('scanner loads managed organizations and rejects viewer relationships',
      () async {
    late RequestOptions request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request = options;
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'data': [
                  {
                    'uuid': 'owner-org',
                    'name': 'Owner Org',
                    'role': 'owner',
                    'logo_url': 'https://example.test/owner.png',
                  },
                  {
                    'uuid': 'manager-org',
                    'display_name': 'Manager Org',
                    'role': 'manager',
                  },
                  {
                    'uuid': 'customer-adherence',
                    'name': 'Customer Adherence',
                    'role': 'viewer',
                  },
                ],
              },
            ),
          );
        },
      ),
    );

    final organizations =
        await ManagedOrganizationsApiDataSource(dio).getManagedOrganizations();

    expect(request.path, '/organizations');
    expect(
      organizations.map((organization) => organization.uuid),
      ['owner-org', 'manager-org'],
    );
    expect(organizations.first.role, OrganizationAccessRole.owner);
    expect(organizations.last.role, OrganizationAccessRole.manager);
  });

  test('legacy persisted staff role maps to backend manager role', () {
    final organization = ActiveOrganization.fromJson(const {
      'uuid': 'legacy-org',
      'name': 'Legacy Org',
      'role': 'staff',
    });

    expect(organization?.role, OrganizationAccessRole.manager);
  });
}
