#include <libusb.h>
#include <stdio.h>

int main(void) {
    libusb_context *ctx = NULL;
    libusb_device **devs;
    ssize_t cnt;
    int r;

    r = libusb_init(&ctx);
    if (r < 0) {
        fprintf(stderr, "Failed to initialize libusb\n");
        return 1;
    }

    cnt = libusb_get_device_list(ctx, &devs);
    if (cnt < 0) {
        fprintf(stderr, "Failed to get device list\n");
        libusb_exit(ctx);
        return 1;
    }

    printf("Found %zd USB devices\n", cnt);

    libusb_free_device_list(devs, 1);
    libusb_exit(ctx);
    return 0;
}
